Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6726A421241
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816310; cv=none; b=MmXiauErDraqg272J+R3Hdh8DbQhHEbebC1IYJOZU9AqxfLs6O5Sd4+JA9EAM0qFWzs0+p2h9mXGQfeJFOiwk1XMM2BoFI2QweloV99Ekm0W4TejcAcBuLnO16/33k6r/yOxIOFTyeTdGiTidMxYoMMsIznL6SLlBDVHTU9uVUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816310; c=relaxed/simple;
	bh=zMKWvpatIU3t5pIZYDikRKlEE6fdDk9mUfjWLnx37YA=;
	h=Date:To:From:Subject:Message-Id; b=tY3Zj16X7BDcDKXhNcTDIC8mh5OrfgP/Bf/TLnYsbYFXvrCcdkPUAmrJVHr1vpmph7dZ9JCDXSv67HvnLGzacgxRpeGuZqHDnPZKxXTnR8LTlMCAsuQac5XXEOjEiiM6h3AGcghivRl5Q7qgGaelTCRt/JMr5Fp6ihBL5dUuYdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ndLXsLGj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ndLXsLGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6131F00A3A;
	Tue,  4 Aug 2026 04:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816309;
	bh=/J+KaC2R8EWBxNJw5uZFftiksY59AFpgyFzGK+hs1WQ=;
	h=Date:To:From:Subject;
	b=ndLXsLGjxOlpvwlL9FTykgfeaMKJdBo5FpXpNtXxB4xXFfg9WTujQMD7eOOw5eib1
	 1J473JMs7yya7tSBsB/dt7u+TEOFT+Sq8SmPtb2MRClgvl22Le/Mrn07dSKHI6NQxe
	 wUZuNrkUjEy07qR8ofApUnzfhAnfdAVQDOJHbWmo=
Date: Mon, 03 Aug 2026 21:05:08 -0700
To: mm-commits@vger.kernel.org,sashiko-bot@kernel.org,gregkh@linuxfoundation.org,giometti@enneenne.com,calvin@wbinvd.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] pps-dont-allow-pps_kc_bind-on-removed-devices.patch removed from -mm tree
Message-Id: <20260804040509.3A6131F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pps: don't allow PPS_KC_BIND on removed devices
has been removed from the -mm tree.  Its filename was
     pps-dont-allow-pps_kc_bind-on-removed-devices.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


