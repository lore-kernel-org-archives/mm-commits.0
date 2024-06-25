Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CFD17995B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719338807; cv=none; b=I5yPgldpLIoc9WF7uToPIQeXykienpc0IHgiHSoMWU1imQx9d2mKql0j3zVn8VS58nHh6nhluTPWdDX7SH7vKtUj4WEGolIwWKxoZczk8r6cLeM2De0J9KqY/lUCZlnF68/4IFuSXxCIQ8Nuoqoaqm7RPZNJ5sQOkjJ8QX6qRrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719338807; c=relaxed/simple;
	bh=Fa0w+zIh4YROXRmlZTD2Rha/3h0l6dTl8pPkYn4FQRA=;
	h=Date:To:From:Subject:Message-Id; b=QpcFdrVpjBd2GLlHthGstRAf8U1fyDBvJjQF3I5ycyzjJo92v395x2WKLI/SP7VS68kn7V95iEnmA7eQv6oFW6Byak1rFozOVgxxXYSUUDZt02BVZ3ujp8JGYOoTHuUScTy4jVjOxWipJKuUy7lij2hXvAyyfP1uWKjJAU6KOSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kWwQeZPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kWwQeZPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F46C32781;
	Tue, 25 Jun 2024 18:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719338807;
	bh=Fa0w+zIh4YROXRmlZTD2Rha/3h0l6dTl8pPkYn4FQRA=;
	h=Date:To:From:Subject:From;
	b=kWwQeZPSRrgwMeY5NPR7m+53CbVWAXepNcTeEUZL6fpHz1doKsaEI967ghxnKUCpm
	 yYchlp6NHKZqW9SrotEgoQra4Whupt3goq4fCb11WT7sjb/WpY7Wckpk7GLCIT7pMD
	 UswlC0htF/CqrvhgbwqI+1ccfcbrBj6WNmAFmctU=
Date: Tue, 25 Jun 2024 11:06:46 -0700
To: mm-commits@vger.kernel.org,wei.liu@kernel.org,wangkefeng.wang@huawei.com,vigneshr@ti.com,ubizjak@gmail.com,tzimmermann@suse.de,tony.luck@intel.com,tglx@linutronix.de,senozhatsky@chromium.org,rostedt@goodmis.org,richard@nod.at,pmladek@suse.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mripard@kernel.org,mpe@ellerman.id.au,miquel.raynal@bootlin.com,maarten.lankhorst@linux.intel.com,kys@microsoft.com,kees@kernel.org,john.ogness@linutronix.de,jani.nikula@intel.com,haiyangz@microsoft.com,gregkh@linuxfoundation.org,gpiccoli@igalia.com,decui@microsoft.com,daniel@ffwll.ch,christophe.leroy@csgroup.eu,airlied@gmail.com,jfalempe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + printk-add-a-short-description-string-to-kmsg_dump.patch added to mm-nonmm-unstable branch
Message-Id: <20240625180646.E7F46C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: printk: add a short description string to kmsg_dump()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     printk-add-a-short-description-string-to-kmsg_dump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/printk-add-a-short-description-string-to-kmsg_dump.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jocelyn Falempe <jfalempe@redhat.com>
Subject: printk: add a short description string to kmsg_dump()
Date: Tue, 25 Jun 2024 14:39:29 +0200

kmsg_dump doesn't forward the panic reason string to the kmsg_dumper
callback.

This patch adds a new parameter "const char *desc" to the kmsg_dumper
dump() callback, and update all drivers that are using it.

To avoid updating all kmsg_dump() call, it adds a kmsg_dump_desc()
function and a macro for backward compatibility.

I've written this for drm_panic, but it can be useful for other
kmsg_dumper.  It allows to see the panic reason, like "sysrq triggered
crash" or "VFS: Unable to mount root fs on xxxx" on the drm panic screen.

Link: https://lkml.kernel.org/r/20240625123954.211184-1-jfalempe@redhat.com
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Kees Cook <kees@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/nvram_64.c             |    3 ++-
 arch/powerpc/platforms/powernv/opal-kmsg.c |    3 ++-
 drivers/gpu/drm/drm_panic.c                |    3 ++-
 drivers/hv/hv_common.c                     |    3 ++-
 drivers/mtd/mtdoops.c                      |    3 ++-
 fs/pstore/platform.c                       |    3 ++-
 include/linux/kmsg_dump.h                  |   13 ++++++++++---
 kernel/panic.c                             |    2 +-
 kernel/printk/printk.c                     |    8 +++++---
 9 files changed, 28 insertions(+), 13 deletions(-)

--- a/arch/powerpc/kernel/nvram_64.c~printk-add-a-short-description-string-to-kmsg_dump
+++ a/arch/powerpc/kernel/nvram_64.c
@@ -643,7 +643,8 @@ void __init nvram_init_oops_partition(in
  * partition.  If that's too much, go back and capture uncompressed text.
  */
 static void oops_to_nvram(struct kmsg_dumper *dumper,
-			  enum kmsg_dump_reason reason)
+			  enum kmsg_dump_reason reason,
+			  const char *desc)
 {
 	struct oops_log_info *oops_hdr = (struct oops_log_info *)oops_buf;
 	static unsigned int oops_count = 0;
--- a/arch/powerpc/platforms/powernv/opal-kmsg.c~printk-add-a-short-description-string-to-kmsg_dump
+++ a/arch/powerpc/platforms/powernv/opal-kmsg.c
@@ -20,7 +20,8 @@
  * message, it just ensures that OPAL completely flushes the console buffer.
  */
 static void kmsg_dump_opal_console_flush(struct kmsg_dumper *dumper,
-				     enum kmsg_dump_reason reason)
+				     enum kmsg_dump_reason reason,
+				     const char *desc)
 {
 	/*
 	 * Outside of a panic context the pollers will continue to run,
--- a/drivers/gpu/drm/drm_panic.c~printk-add-a-short-description-string-to-kmsg_dump
+++ a/drivers/gpu/drm/drm_panic.c
@@ -488,7 +488,8 @@ static struct drm_plane *to_drm_plane(st
 	return container_of(kd, struct drm_plane, kmsg_panic);
 }
 
-static void drm_panic(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason)
+static void drm_panic(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
+		      const char *desc)
 {
 	struct drm_plane *plane = to_drm_plane(dumper);
 
--- a/drivers/hv/hv_common.c~printk-add-a-short-description-string-to-kmsg_dump
+++ a/drivers/hv/hv_common.c
@@ -207,7 +207,8 @@ static int hv_die_panic_notify_crash(str
  * buffer and call into Hyper-V to transfer the data.
  */
 static void hv_kmsg_dump(struct kmsg_dumper *dumper,
-			 enum kmsg_dump_reason reason)
+			 enum kmsg_dump_reason reason,
+			 const char *desc)
 {
 	struct kmsg_dump_iter iter;
 	size_t bytes_written;
--- a/drivers/mtd/mtdoops.c~printk-add-a-short-description-string-to-kmsg_dump
+++ a/drivers/mtd/mtdoops.c
@@ -298,7 +298,8 @@ static void find_next_position(struct mt
 }
 
 static void mtdoops_do_dump(struct kmsg_dumper *dumper,
-			    enum kmsg_dump_reason reason)
+			    enum kmsg_dump_reason reason,
+			    const char *desc)
 {
 	struct mtdoops_context *cxt = container_of(dumper,
 			struct mtdoops_context, dump);
--- a/fs/pstore/platform.c~printk-add-a-short-description-string-to-kmsg_dump
+++ a/fs/pstore/platform.c
@@ -275,7 +275,8 @@ void pstore_record_init(struct pstore_re
  * end of the buffer.
  */
 static void pstore_dump(struct kmsg_dumper *dumper,
-			enum kmsg_dump_reason reason)
+			enum kmsg_dump_reason reason,
+			const char *desc)
 {
 	struct kmsg_dump_iter iter;
 	unsigned long	total = 0;
--- a/include/linux/kmsg_dump.h~printk-add-a-short-description-string-to-kmsg_dump
+++ a/include/linux/kmsg_dump.h
@@ -49,13 +49,15 @@ struct kmsg_dump_iter {
  */
 struct kmsg_dumper {
 	struct list_head list;
-	void (*dump)(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason);
+	void (*dump)(struct kmsg_dumper *dumper,
+		     enum kmsg_dump_reason reason,
+		     const char *desc);
 	enum kmsg_dump_reason max_reason;
 	bool registered;
 };
 
 #ifdef CONFIG_PRINTK
-void kmsg_dump(enum kmsg_dump_reason reason);
+void kmsg_dump_desc(enum kmsg_dump_reason reason, const char *desc);
 
 bool kmsg_dump_get_line(struct kmsg_dump_iter *iter, bool syslog,
 			char *line, size_t size, size_t *len);
@@ -71,7 +73,7 @@ int kmsg_dump_unregister(struct kmsg_dum
 
 const char *kmsg_dump_reason_str(enum kmsg_dump_reason reason);
 #else
-static inline void kmsg_dump(enum kmsg_dump_reason reason)
+static inline void kmsg_dump_desc(enum kmsg_dump_reason reason, const char *desc)
 {
 }
 
@@ -107,4 +109,9 @@ static inline const char *kmsg_dump_reas
 }
 #endif
 
+static inline void kmsg_dump(enum kmsg_dump_reason reason)
+{
+	kmsg_dump_desc(reason, NULL);
+}
+
 #endif /* _LINUX_KMSG_DUMP_H */
--- a/kernel/panic.c~printk-add-a-short-description-string-to-kmsg_dump
+++ a/kernel/panic.c
@@ -376,7 +376,7 @@ void panic(const char *fmt, ...)
 
 	panic_print_sys_info(false);
 
-	kmsg_dump(KMSG_DUMP_PANIC);
+	kmsg_dump_desc(KMSG_DUMP_PANIC, buf);
 
 	/*
 	 * If you doubt kdump always works fine in any situation,
--- a/kernel/printk/printk.c~printk-add-a-short-description-string-to-kmsg_dump
+++ a/kernel/printk/printk.c
@@ -4126,14 +4126,16 @@ const char *kmsg_dump_reason_str(enum km
 EXPORT_SYMBOL_GPL(kmsg_dump_reason_str);
 
 /**
- * kmsg_dump - dump kernel log to kernel message dumpers.
+ * kmsg_dump_desc - dump kernel log to kernel message dumpers.
  * @reason: the reason (oops, panic etc) for dumping
+ * @desc: a short string to describe what caused the panic or oops. Can be NULL
+ * if no additional description is available.
  *
  * Call each of the registered dumper's dump() callback, which can
  * retrieve the kmsg records with kmsg_dump_get_line() or
  * kmsg_dump_get_buffer().
  */
-void kmsg_dump(enum kmsg_dump_reason reason)
+void kmsg_dump_desc(enum kmsg_dump_reason reason, const char *desc)
 {
 	struct kmsg_dumper *dumper;
 
@@ -4153,7 +4155,7 @@ void kmsg_dump(enum kmsg_dump_reason rea
 			continue;
 
 		/* invoke dumper which will iterate over records */
-		dumper->dump(dumper, reason);
+		dumper->dump(dumper, reason, desc);
 	}
 	rcu_read_unlock();
 }
_

Patches currently in -mm which might be from jfalempe@redhat.com are

printk-add-a-short-description-string-to-kmsg_dump.patch

