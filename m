From: akpm@linux-foundation.org
Subject: [merged] lis3lv02d-avoid-divide-by-zero-due-to-unchecked.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:13:06 -0700
Message-ID: <201111012113.pA1LD7L4028117@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16203 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, cascardo@holoscopio.com, chunkeey@googlemail.com, ilkka.koskinen@nokia.com, lyall.pearce@hp.com, m-starostik@versanet.de, mjg@redhat.com, witold.pilat@gmai


The patch titled
     Subject: lis3lv02d: avoid divide by zero due to unchecked
has been removed from the -mm tree.  Its filename was
     lis3lv02d-avoid-divide-by-zero-due-to-unchecked.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: =C9ric Piel <eric.piel@tremplin-utc.net>
Subject: lis3lv02d: avoid divide by zero due to unchecked

After an "unexpected" reboot, I found this Oops in my logs:

divide error: 0000 [#1] PREEMPT SMP=3D20
CPU 0=3D20
Modules linked in: lis3lv02d hp_wmi input_polldev [...]
Pid: 390, comm: modprobe Tainted: G         C  2.6.39-rc7-wl+=3D20
RIP: 0010:[<ffffffffa014b427>]  [<ffffffffa014b427>]
		 lis3lv02d_poweron+0x4e/0x94 [lis3lv02d]
RSP: 0018:ffff8801d6407cf8  EFLAGS: 00010246
RAX: 0000000000000bb8 RBX: ffffffffa014e000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffea00066e4708 RDI: ffff8801df002700
RBP: ffff8801d6407d18 R08: ffffea00066c5a30 R09: ffffffff812498c9
R10: ffff8801d7bfcea0 R11: ffff8801d7bfce10 R12: 0000000000000bb8
R13: 00000000ffffffda R14: ffffffffa0154120 R15: ffffffffa0154030
=3D46S:  00007fc0705db700(0000) GS:ffff8801dfa00000(0000) knlGS:0
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f33549174f0 CR3: 00000001d65c9000 CR4: 00000000000406f0
Process modprobe (pid: 390, threadinfo ffff8801d6406000, task ffff8801d=
6b40=3D
000)
Stack:
 ffffffffa0154120 62ffffffa0154030 ffffffffa014e000 00000000ffffffea
 ffff8801d6407d58 ffffffffa014bcc1 0000000000000000 0000000000000048
 ffff8801d8bae800 00000000ffffffea 00000000ffffffda ffffffffa0154120
Call Trace:
 [<ffffffffa014bcc1>] lis3lv02d_init_device+0x1ce/0x496 [lis3lv02d]
 [<ffffffffa01522ff>] lis3lv02d_add+0x10f/0x17c [hp_accel]
 [<ffffffff81233e11>] acpi_device_probe+0x49/0x117
[...]
Code: 3a 75 06 80 4d ef 50 eb 04 80 4d ef 40 0f b6 55 ef be 21
00 00 00 48 89 df ff 53 18 44 8b 63 6c e8 3e fc ff ff 89 c1 44
89 e0 99 <f7> f9 89 c7 e8 93 82 ef e0 48 83 7b 30 00 74 2d 45
31 e4 80 7b=3D20
RIP  [<ffffffffa014b427>] lis3lv02d_poweron+0x4e/0x94 [lis3lv02d]
 RSP <ffff8801d6407cf8>

From my POV, it looks like the hardware is not working as expected
and returns a bogus data rate. The driver doesn't check the result
and directly uses it as some sort of divisor in some places:

msleep(lis3->pwron_delay / lis3lv02d_get_odr());

Under this circumstances, this could very well cause the
"divide by zero" exception from above.

=46or now, I fixed it the easiest and most obvious way:
Check if the result is sane and if it isn't use a sane default
instead. I went for "100" in the latter case, simply because
/sys/devices/platform/lis3lv02d/rate returns it on a successful
boot.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: =C9ric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Witold Pilat <witold.pilat@gmail.com>
Cc: Lyall Pearce <lyall.pearce@hp.com>
Cc: Malte Starostik <m-starostik@versanet.de>
Cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d.c |   36 ++++++++++++++++++++++-----
 drivers/misc/lis3lv02d/lis3lv02d.h |    2 -
 drivers/platform/x86/hp_accel.c    |    3 --
 3 files changed, 32 insertions(+), 9 deletions(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d.c~lis3lv02d-avoid-divide-by-=
zero-due-to-unchecked drivers/misc/lis3lv02d/lis3lv02d.c
--- a/drivers/misc/lis3lv02d/lis3lv02d.c~lis3lv02d-avoid-divide-by-zero=
-due-to-unchecked
+++ a/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -206,6 +206,18 @@ static int lis3lv02d_get_odr(void)
 	return lis3_dev.odrs[(ctrl >> shift)];
 }
=20
+static int lis3lv02d_get_pwron_wait(struct lis3lv02d *lis3)
+{
+	int div =3D lis3lv02d_get_odr();
+
+	if (WARN_ONCE(div =3D=3D 0, "device returned spurious data"))
+		return -ENXIO;
+
+	/* LIS3 power on delay is quite long */
+	msleep(lis3->pwron_delay / div);
+	return 0;
+}
+
 static int lis3lv02d_set_odr(int rate)
 {
 	u8 ctrl;
@@ -266,7 +278,9 @@ static int lis3lv02d_selftest(struct lis
=20
 	lis3->read(lis3, ctlreg, &reg);
 	lis3->write(lis3, ctlreg, (reg | selftest));
-	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+	ret =3D lis3lv02d_get_pwron_wait(lis3);
+	if (ret)
+		goto fail;
=20
 	/* Read directly to avoid axis remap */
 	x =3D lis3->read_data(lis3, OUTX);
@@ -275,7 +289,9 @@ static int lis3lv02d_selftest(struct lis
=20
 	/* back to normal settings */
 	lis3->write(lis3, ctlreg, reg);
-	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+	ret =3D lis3lv02d_get_pwron_wait(lis3);
+	if (ret)
+		goto fail;
=20
 	results[0] =3D x - lis3->read_data(lis3, OUTX);
 	results[1] =3D y - lis3->read_data(lis3, OUTY);
@@ -363,8 +379,9 @@ void lis3lv02d_poweroff(struct lis3lv02d
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
=20
-void lis3lv02d_poweron(struct lis3lv02d *lis3)
+int lis3lv02d_poweron(struct lis3lv02d *lis3)
 {
+	int err;
 	u8 reg;
=20
 	lis3->init(lis3);
@@ -384,11 +401,14 @@ void lis3lv02d_poweron(struct lis3lv02d=20
 		lis3->write(lis3, CTRL_REG2, reg);
 	}
=20
-	/* LIS3 power on delay is quite long */
-	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+	err =3D lis3lv02d_get_pwron_wait(lis3);
+	if (err)
+		return err;
=20
 	if (lis3->reg_ctrl)
 		lis3_context_restore(lis3);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
=20
@@ -928,7 +948,11 @@ int lis3lv02d_init_device(struct lis3lv0
 	atomic_set(&dev->wake_thread, 0);
=20
 	lis3lv02d_add_fs(dev);
-	lis3lv02d_poweron(dev);
+	err =3D lis3lv02d_poweron(dev);
+	if (err) {
+		lis3lv02d_remove_fs(dev);
+		return err;
+	}
=20
 	if (dev->pm_dev) {
 		pm_runtime_set_active(dev->pm_dev);
diff -puN drivers/misc/lis3lv02d/lis3lv02d.h~lis3lv02d-avoid-divide-by-=
zero-due-to-unchecked drivers/misc/lis3lv02d/lis3lv02d.h
--- a/drivers/misc/lis3lv02d/lis3lv02d.h~lis3lv02d-avoid-divide-by-zero=
-due-to-unchecked
+++ a/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -285,7 +285,7 @@ int lis3lv02d_init_device(struct lis3lv0
 int lis3lv02d_joystick_enable(void);
 void lis3lv02d_joystick_disable(void);
 void lis3lv02d_poweroff(struct lis3lv02d *lis3);
-void lis3lv02d_poweron(struct lis3lv02d *lis3);
+int lis3lv02d_poweron(struct lis3lv02d *lis3);
 int lis3lv02d_remove_fs(struct lis3lv02d *lis3);
=20
 extern struct lis3lv02d lis3_dev;
diff -puN drivers/platform/x86/hp_accel.c~lis3lv02d-avoid-divide-by-zer=
o-due-to-unchecked drivers/platform/x86/hp_accel.c
--- a/drivers/platform/x86/hp_accel.c~lis3lv02d-avoid-divide-by-zero-du=
e-to-unchecked
+++ a/drivers/platform/x86/hp_accel.c
@@ -354,8 +354,7 @@ static int lis3lv02d_suspend(struct acpi
=20
 static int lis3lv02d_resume(struct acpi_device *device)
 {
-	lis3lv02d_poweron(&lis3_dev);
-	return 0;
+	return lis3lv02d_poweron(&lis3_dev);
 }
 #else
 #define lis3lv02d_suspend NULL
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net=
 are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
