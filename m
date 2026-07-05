Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1EE35E940
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783282831; cv=none; b=DDodzsrgK91V384tNIh7RFs6H4830mcWdp2fcxvA4FjBwSRnyKauYsdgtiShlaxozz5IGOF9mdf1kPgCshNc589+7UoT5UAa+bsmcXHPqY7FLM4hdvgE+X9DwpSflgeUNNabAWdsbP0QAqRhWoA2CEpW5IkzXlC+s4GbxUde5OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783282831; c=relaxed/simple;
	bh=hhykGrCq2V78+tJ7vRDEwvpocFA1m3RG8+nfbUO6iF4=;
	h=Date:To:From:Subject:Message-Id; b=pBJ807vzWdHktnGRULKXVdiWD6XSZt2t1HdZ+My4mBTKhY9bvsUHWLqpOFcicG/L34MuvhIcH28GEGSVOr/V13YVRmL+8r1cb6leA0NiV6N64zeeUKxZZcw1bV8is88CIlzkBb7LyM3G4jDSg3bTev4hUi1ncIQGErelA/jeN4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yn+WsPwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yn+WsPwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191991F000E9;
	Sun,  5 Jul 2026 20:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783282830;
	bh=gtnmY1hz89uQjfHeW+nL9nAW/EfSyj7sxyii5tXnA/w=;
	h=Date:To:From:Subject;
	b=Yn+WsPwlyjOclE3CRTjqptZe6JP4jet/jzm1IV3Oh9O722ZbjErEiuT4+K45YB3te
	 xx6NWBVL2pmA6rwSDd/AR1UR7noNWopvBXD0O3Cm78QsdT+myom340VM/NdNTyt35k
	 spVcrqOWnF+6q2sgUf0FIVHbY8y5pSPF2C0ZO0FA=
Date: Sun, 05 Jul 2026 13:20:29 -0700
To: mm-commits@vger.kernel.org,sashiko-bot@kernel.org,gregkh@linuxfoundation.org,giometti@enneenne.com,calvin@wbinvd.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pps-dont-allow-pps_kc_bind-on-removed-devices.patch added to mm-nonmm-unstable branch
Message-Id: <20260705202030.191991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pps: don't allow PPS_KC_BIND on removed devices
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pps-dont-allow-pps_kc_bind-on-removed-devices.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pps-dont-allow-pps_kc_bind-on-removed-devices.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Calvin Owens <calvin@wbinvd.org>
Subject: pps: don't allow PPS_KC_BIND on removed devices
Date: Wed, 3 Jun 2026 10:25:44 -0700

If userspace holds its file descriptor open, it can call PPS_KC_BIND on a
device which has been unplugged, leaving pps_kc_hardpps_dev as a dangling
pointer after close().

After that sequence, PPS_KC_BIND is broken until the system is rebooted,
because the pointer comparison in pps_kc_bind() can never be true.

    calling  pps_ktimer_init+0x0/0x1000 [pps_ktimer] @ 1081
    initcall pps_ktimer_init+0x0/0x1000 [pps_ktimer] returned 0 after 811 usecs
    pps pps0: bound kernel consumer: edge=0x1
    pps pps0: unbound kernel consumer on device removal
    pps pps0: bound kernel consumer: edge=0x1
    calling  pps_ktimer_init+0x0/0x1000 [pps_ktimer] @ 1085
    initcall pps_ktimer_init+0x0/0x1000 [pps_ktimer] returned 0 after 340 usecs
    pps pps0: another kernel consumer is already bound

Here is a short reproducer, which uses rmmod of the pps-ktimer testcase
to simulate a device being unplugged:

    #include <stdlib.h>
    #include <stdio.h>
    #include <unistd.h>
    #include <fcntl.h>
    #include <sys/ioctl.h>
    #include <linux/pps.h>
    #include <errno.h>
    #include <err.h>

    int main(void)
    {
        while (1) {
            int fd;

            if (system("insmod ./pps-ktimer.ko"))
                err(1, "insmod failed");

            fd = open("/dev/pps0", O_RDWR);
            if (fd == -1)
                err(1, "open failed");

            struct pps_bind_args args = {
                .tsformat = PPS_TSFMT_TSPEC,
                .edge = PPS_CAPTUREASSERT,
                .consumer = PPS_KC_HARDPPS,
            };

            if (ioctl(fd, PPS_KC_BIND, &args))
                err(1, "first PPS_KC_BIND failed");

            if (system("rmmod pps-ktimer"))
                err(1, "rmmod failed");

            if (ioctl(fd, PPS_KC_BIND, &args)) {
                if (errno != ENODEV)
                    err(1, "second PPS_KC_BIND failed");
                else
                    puts("Got ENODEV, kernel is patched");
            }

            close(fd);
        }
    }

Fix this by setting a flag when the device is unplugged, returning -ENODEV
from PPS_KC_BIND if the flag is set.

For userspace to encounter this new behavior, it must do something which
breaks the interface today, so this fix shouldn't cause any observable
behavior change for working programs.

Link: https://lore.kernel.org/672778c177ac9b6fdcb445e35c97ac4ca7d1149f.1780506611.git.calvin@wbinvd.org
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1779733602.git.calvin%40wbinvd.org?part=1
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kc.c           |   10 ++++++++++
 include/linux/pps_kernel.h |    1 +
 2 files changed, 11 insertions(+)

--- a/drivers/pps/kc.c~pps-dont-allow-pps_kc_bind-on-removed-devices
+++ a/drivers/pps/kc.c
@@ -38,6 +38,14 @@ int pps_kc_bind(struct pps_device *pps,
 	/* Check if another consumer is already bound */
 	spin_lock_irq(&pps_kc_hardpps_lock);
 
+	/*
+	 * Don't allow PPS_KC_BIND on a removed device.
+	 */
+	if (pps->kc_removed) {
+		spin_unlock_irq(&pps_kc_hardpps_lock);
+		return -ENODEV;
+	}
+
 	if (bind_args->edge == 0)
 		if (pps_kc_hardpps_dev == pps) {
 			pps_kc_hardpps_mode = 0;
@@ -79,6 +87,8 @@ int pps_kc_bind(struct pps_device *pps,
 void pps_kc_remove(struct pps_device *pps)
 {
 	spin_lock_irq(&pps_kc_hardpps_lock);
+
+	pps->kc_removed = true;
 	if (pps == pps_kc_hardpps_dev) {
 		pps_kc_hardpps_mode = 0;
 		pps_kc_hardpps_dev = NULL;
--- a/include/linux/pps_kernel.h~pps-dont-allow-pps_kc_bind-on-removed-devices
+++ a/include/linux/pps_kernel.h
@@ -60,6 +60,7 @@ struct pps_device {
 	struct device dev;
 	struct fasync_struct *async_queue;	/* fasync method */
 	spinlock_t lock;
+	bool kc_removed;
 };
 
 /*
_

Patches currently in -mm which might be from calvin@wbinvd.org are

pps-dont-try-to-wait-for-negative-timeouts-in-pps_fetch.patch
pps-dont-allow-pps_kc_bind-on-removed-devices.patch

