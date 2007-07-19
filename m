From: akpm@linux-foundation.org
Subject: - swsusp-introduce-restore-platform-operations.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:03 -0700
Message-ID: <200707192000.l6JK031f019417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758206AbXGSUAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:00:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, nigel@nigel.suspend2.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: introduce restore platform operations
has been removed from the -mm tree.  Its filename was
     swsusp-introduce-restore-platform-operations.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: swsusp: introduce restore platform operations
=46rom: Rafael J. Wysocki <rjw@sisk.pl>

At least on some machines it is necessary to prepare the ACPI firmware =
for the
restoration of the system memory state from the hibernation image if th=
e
"platform" mode of hibernation has been used.  Namely, in that cases we=
 need
to disable the GPEs before replacing the "boot" kernel with the "frozen=
"
kernel (cf.  http://bugzilla.kernel.org/show_bug.cgi?id=3D7887).  After=
 the
restore they will be re-enabled by hibernation_ops->finish(), but if th=
e
restore fails, they have to be re-enabled by the restore code explicitl=
y.

=46or this purpose we can introduce two additional hibernation operatio=
ns,
called pre_restore() and restore_cleanup() and call them from the resto=
re code
path.  Still, they should be called if the "platform" mode of hibernati=
on has
been used, so we need to pass the information about the hibernation mod=
e from
the "frozen" kernel to the "boot" kernel in the image header.

Apparently, we can't drop the disabling of GPEs before the restore beca=
use of
Bug #7887 .  =A0We also can't do it unconditionally, because the GPEs w=
ouldn't
have been enabled after a successful restore if the suspend had been do=
ne in
the 'shutdown' or 'reboot' mode.

In principle we could (and probably should) unconditionally disable the=
 GPEs
before each snapshot creation *and* before the restore, but then we'd h=
ave to
unconditionally enable them after the snapshot creation as well as afte=
r the
restore (or restore failure) =A0 Still, for this purpose we'd need to m=
odify
acpi_enter_sleep_state_prep() and acpi_leave_sleep_state() and we'd hav=
e to
introduce some mechanism synchronizing the disablind/enabling of the GP=
Es with
the device drivers' .suspend()/.resume() routines and with
disable_/enable_nonboot_cpus().  =A0However, this would have affected t=
he
suspend (ie.  s2ram) code as well as the hibernation, which I'd like to=
 avoid
in this patch series.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/main.c |   16 ++++++++++
 include/linux/suspend.h   |    4 ++
 kernel/power/disk.c       |   56 +++++++++++++++++++++++++++++-------
 kernel/power/power.h      |   13 ++++++--
 kernel/power/swap.c       |   20 +++++++++---
 kernel/power/user.c       |    2 -
 6 files changed, 92 insertions(+), 19 deletions(-)

diff -puN drivers/acpi/sleep/main.c~swsusp-introduce-restore-platform-o=
perations drivers/acpi/sleep/main.c
--- a/drivers/acpi/sleep/main.c~swsusp-introduce-restore-platform-opera=
tions
+++ a/drivers/acpi/sleep/main.c
@@ -217,10 +217,26 @@ static void acpi_hibernation_finish(void
 	}
 }
=20
+static int acpi_hibernation_pre_restore(void)
+{
+	acpi_status status;
+
+	status =3D acpi_hw_disable_all_gpes();
+
+	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
+}
+
+static void acpi_hibernation_restore_cleanup(void)
+{
+	acpi_hw_enable_all_runtime_gpes();
+}
+
 static struct hibernation_ops acpi_hibernation_ops =3D {
 	.prepare =3D acpi_hibernation_prepare,
 	.enter =3D acpi_hibernation_enter,
 	.finish =3D acpi_hibernation_finish,
+	.pre_restore =3D acpi_hibernation_pre_restore,
+	.restore_cleanup =3D acpi_hibernation_restore_cleanup,
 };
 #endif				/* CONFIG_SOFTWARE_SUSPEND */
=20
diff -puN include/linux/suspend.h~swsusp-introduce-restore-platform-ope=
rations include/linux/suspend.h
--- a/include/linux/suspend.h~swsusp-introduce-restore-platform-operati=
ons
+++ a/include/linux/suspend.h
@@ -43,11 +43,15 @@ static inline void pm_restore_console(vo
  * @prepare: prepare system for hibernation
  * @enter: shut down system after state has been saved to disk
  * @finish: finish/clean up after state has been reloaded
+ * @pre_restore: prepare system for the restoration from a hibernation=
 image
+ * @restore_cleanup: clean up after a failing image restoration
  */
 struct hibernation_ops {
 	int (*prepare)(void);
 	int (*enter)(void);
 	void (*finish)(void);
+	int (*pre_restore)(void);
+	void (*restore_cleanup)(void);
 };
=20
 #if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
diff -puN kernel/power/disk.c~swsusp-introduce-restore-platform-operati=
ons kernel/power/disk.c
--- a/kernel/power/disk.c~swsusp-introduce-restore-platform-operations
+++ a/kernel/power/disk.c
@@ -54,7 +54,8 @@ static struct hibernation_ops *hibernati
=20
 void hibernation_set_ops(struct hibernation_ops *ops)
 {
-	if (ops && !(ops->prepare && ops->enter && ops->finish)) {
+	if (ops && !(ops->prepare && ops->enter && ops->finish
+	    && ops->pre_restore && ops->restore_cleanup)) {
 		WARN_ON(1);
 		return;
 	}
@@ -92,6 +93,31 @@ static void platform_finish(int platform
 }
=20
 /**
+ *	platform_pre_restore - prepare the platform for the restoration fro=
m a
+ *	hibernation image.  If the restore fails after this function has be=
en
+ *	called, platform_restore_cleanup() must be called.
+ */
+
+static int platform_pre_restore(int platform_mode)
+{
+	return (platform_mode && hibernation_ops) ?
+		hibernation_ops->pre_restore() : 0;
+}
+
+/**
+ *	platform_restore_cleanup - switch the platform to the normal mode o=
f
+ *	operation after a failing restore.  If platform_pre_restore() has b=
een
+ *	called before the failing restore, this function must be called too=
,
+ *	regardless of the result of platform_pre_restore().
+ */
+
+static void platform_restore_cleanup(int platform_mode)
+{
+	if (platform_mode && hibernation_ops)
+		hibernation_ops->restore_cleanup();
+}
+
+/**
  *	hibernation_snapshot - quiesce devices and create the hibernation
  *	snapshot image.
  *	@platform_mode - if set, use the platform driver, if available, to
@@ -141,11 +167,13 @@ int hibernation_snapshot(int platform_mo
 /**
  *	hibernation_restore - quiesce devices and restore the hibernation
  *	snapshot image.  If successful, control returns in hibernation_snap=
hot()
+ *	@platform_mode - if set, use the platform driver, if available, to
+ *			 prepare the platform frimware for the transition.
  *
  *	Must be called with pm_mutex held
  */
=20
-int hibernation_restore(void)
+int hibernation_restore(int platform_mode)
 {
 	int error;
=20
@@ -155,11 +183,14 @@ int hibernation_restore(void)
 	if (error)
 		goto Finish;
=20
-	error =3D disable_nonboot_cpus();
-	if (!error)
-		error =3D swsusp_resume();
-
-	enable_nonboot_cpus();
+	error =3D platform_pre_restore(platform_mode);
+	if (!error) {
+		error =3D disable_nonboot_cpus();
+		if (!error)
+			error =3D swsusp_resume();
+		enable_nonboot_cpus();
+	}
+	platform_restore_cleanup(platform_mode);
  Finish:
 	device_resume();
 	resume_console();
@@ -260,8 +291,12 @@ int hibernate(void)
 	}
 	error =3D hibernation_snapshot(hibernation_mode =3D=3D HIBERNATION_PL=
ATFORM);
 	if (in_suspend && !error) {
+		unsigned int flags =3D 0;
+
+		if (hibernation_mode =3D=3D HIBERNATION_PLATFORM)
+			flags |=3D SF_PLATFORM_MODE;
 		pr_debug("PM: writing image.\n");
-		error =3D swsusp_write();
+		error =3D swsusp_write(flags);
 		swsusp_free();
 		if (!error)
 			power_down();
@@ -295,6 +330,7 @@ int hibernate(void)
 static int software_resume(void)
 {
 	int error;
+	unsigned int flags;
=20
 	mutex_lock(&pm_mutex);
 	if (!swsusp_resume_device) {
@@ -342,9 +378,9 @@ static int software_resume(void)
=20
 	pr_debug("PM: Reading swsusp image.\n");
=20
-	error =3D swsusp_read();
+	error =3D swsusp_read(&flags);
 	if (!error)
-		hibernation_restore();
+		hibernation_restore(flags & SF_PLATFORM_MODE);
=20
 	printk(KERN_ERR "PM: Restore failed, recovering.\n");
 	swsusp_free();
diff -puN kernel/power/power.h~swsusp-introduce-restore-platform-operat=
ions kernel/power/power.h
--- a/kernel/power/power.h~swsusp-introduce-restore-platform-operations
+++ a/kernel/power/power.h
@@ -27,7 +27,7 @@ struct swsusp_info {
=20
 /* kernel/power/disk.c */
 extern int hibernation_snapshot(int platform_mode);
-extern int hibernation_restore(void);
+extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
 #endif
=20
@@ -155,13 +155,20 @@ extern sector_t alloc_swapdev_block(int=20
 extern void free_all_swap_pages(int swap);
 extern int swsusp_swap_in_use(void);
=20
+/*
+ * Flags that can be passed from the hibernatig hernel to the "boot" k=
ernel in
+ * the image header.
+ */
+#define SF_PLATFORM_MODE	1
+
+/* kernel/power/disk.c */
 extern int swsusp_check(void);
 extern int swsusp_shrink_memory(void);
 extern void swsusp_free(void);
 extern int swsusp_suspend(void);
 extern int swsusp_resume(void);
-extern int swsusp_read(void);
-extern int swsusp_write(void);
+extern int swsusp_read(unsigned int *flags_p);
+extern int swsusp_write(unsigned int flags);
 extern void swsusp_close(void);
 extern int suspend_enter(suspend_state_t state);
=20
diff -puN kernel/power/swap.c~swsusp-introduce-restore-platform-operati=
ons kernel/power/swap.c
--- a/kernel/power/swap.c~swsusp-introduce-restore-platform-operations
+++ a/kernel/power/swap.c
@@ -33,8 +33,9 @@ extern char resume_file[];
 #define SWSUSP_SIG	"S1SUSPEND"
=20
 struct swsusp_header {
-	char reserved[PAGE_SIZE - 20 - sizeof(sector_t)];
+	char reserved[PAGE_SIZE - 20 - sizeof(sector_t) - sizeof(int)];
 	sector_t image;
+	unsigned int flags;	/* Flags to pass to the "boot" kernel */
 	char	orig_sig[10];
 	char	sig[10];
 } __attribute__((packed));
@@ -138,7 +139,7 @@ static int wait_on_bio_chain(struct bio=20
  * Saving part
  */
=20
-static int mark_swapfiles(sector_t start)
+static int mark_swapfiles(sector_t start, unsigned int flags)
 {
 	int error;
=20
@@ -148,6 +149,7 @@ static int mark_swapfiles(sector_t start
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
 		memcpy(swsusp_header->sig,SWSUSP_SIG, 10);
 		swsusp_header->image =3D start;
+		swsusp_header->flags =3D flags;
 		error =3D bio_write_page(swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
@@ -369,6 +371,7 @@ static int enough_swap(unsigned int nr_p
=20
 /**
  *	swsusp_write - Write entire image and metadata.
+ *	@flags: flags to pass to the "boot" kernel in the image header
  *
  *	It is important _NOT_ to umount filesystems at this point. We want
  *	them synced (in case something goes wrong) but we DO not want to ma=
rk
@@ -376,7 +379,7 @@ static int enough_swap(unsigned int nr_p
  *	correctly, we'll mark system clean, anyway.)
  */
=20
-int swsusp_write(void)
+int swsusp_write(unsigned int flags)
 {
 	struct swap_map_handle handle;
 	struct snapshot_handle snapshot;
@@ -415,7 +418,7 @@ int swsusp_write(void)
 		if (!error) {
 			flush_swap_writer(&handle);
 			printk("S");
-			error =3D mark_swapfiles(start);
+			error =3D mark_swapfiles(start, flags);
 			printk("|\n");
 		}
 	}
@@ -540,13 +543,20 @@ static int load_image(struct swap_map_ha
 	return error;
 }
=20
-int swsusp_read(void)
+/**
+ *	swsusp_read - read the hibernation image.
+ *	@flags_p: flags passed by the "frozen" kernel in the image header s=
hould
+ *		  be written into this memeory location
+ */
+
+int swsusp_read(unsigned int *flags_p)
 {
 	int error;
 	struct swap_map_handle handle;
 	struct snapshot_handle snapshot;
 	struct swsusp_info *header;
=20
+	*flags_p =3D swsusp_header->flags;
 	if (IS_ERR(resume_bdev)) {
 		pr_debug("swsusp: block device not initialised\n");
 		return PTR_ERR(resume_bdev);
diff -puN kernel/power/user.c~swsusp-introduce-restore-platform-operati=
ons kernel/power/user.c
--- a/kernel/power/user.c~swsusp-introduce-restore-platform-operations
+++ a/kernel/power/user.c
@@ -188,7 +188,7 @@ static int snapshot_ioctl(struct inode *
 			error =3D -EPERM;
 			break;
 		}
-		error =3D hibernation_restore();
+		error =3D hibernation_restore(data->platform_suspend);
 		break;
=20
 	case SNAPSHOT_FREE:
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
acpi-implement-the-set_target-callback-from-pm_ops.patch
acpi-add-acpi_pm_device_sleep_state-helper-routine.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-fix-compilation-of-suspend-code-if-config_pm-is-unset.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
shrink_slab-handle-bad-shrinkers.patch
