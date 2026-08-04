Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324904229BA
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816309; cv=none; b=F5AHyiU4h6hVY64/1AZ1/yG3Xl8vC4QGcog/rA8Awtd+l+1PJdYAaehRMZ+/XmfPjVRVpV9TW6KJfX5R77p9vvc+mt2XDP8uOLyLSt5hIIo8eg1ONhUXPQsANPKUFXPeERlUgkiDTygXtRfBOjy4dg3W5onC+epAh4UddD3JNxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816309; c=relaxed/simple;
	bh=2acyZufpTj3RO7jazuP874g41aH5Axx2Xuz23eG9JlQ=;
	h=Date:To:From:Subject:Message-Id; b=ekfe5SCZsF/ioujedyT8oVNpGqgcc9X3ihf0dYb68R2RiZJw9/oCpfU00ouBiB16PCQ551pmDfbjxF85LNOYlFY9AZfzuh8hJJD2q3OYpbkgZwBZ8PeN7BjEj3qEca42+AZhYDsbk+pcnLhYCZdnt69FnZnzJIkc6irSimV9hIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v8jJSnAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v8jJSnAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068501F000E9;
	Tue,  4 Aug 2026 04:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816308;
	bh=KZdEWiiK22MIFInxbqH1lZYNIRyY/kZnd2uldbzn7AU=;
	h=Date:To:From:Subject;
	b=v8jJSnAMcnVCHokExtGVnUvNabi8X/KOS63BnEEvYSQK2qXWhIrDHWA/Djy2K2jVE
	 D3/gzOKOGmdER6o+fWqaWaU97GJkYB9IxkkSzBnQWjKnFZi6KFxnRF1l6pQZy2E8/k
	 +luJWQ1QXrjzdqXn4d/u2d1RdN1zBD7YM9iR3xzw=
Date: Mon, 03 Aug 2026 21:05:07 -0700
To: mm-commits@vger.kernel.org,sashiko-bot@kernel.org,gregkh@linuxfoundation.org,giometti@enneenne.com,calvin@wbinvd.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] pps-dont-try-to-wait-for-negative-timeouts-in-pps_fetch.patch removed from -mm tree
Message-Id: <20260804040508.068501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pps: don't try to wait for negative timeouts in PPS_FETCH
has been removed from the -mm tree.  Its filename was
     pps-dont-try-to-wait-for-negative-timeouts-in-pps_fetch.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Calvin Owens <calvin@wbinvd.org>
Subject: pps: don't try to wait for negative timeouts in PPS_FETCH
Date: Fri, 12 Jun 2026 11:52:09 -0700

If userspace passes a negative timeout to PPS_FETCH, it triggers a kernel
splat from schedule_timeout():

    schedule_timeout: wrong timeout value fffffffffff0bfb4
    CPU: 17 UID: 0 PID: 4720 Comm: a.out Not tainted 7.1.0-rc5-x86-kvm-00150-g331d97e36b37 #1 PREEMPT_RT
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-20240910_120124-localhost 04/01/2014
    Call Trace:
     <TASK>
     dump_stack_lvl+0x4b/0x70
     schedule_timeout+0xb7/0xe0
     pps_cdev_pps_fetch.isra.0+0x93/0x150
     pps_cdev_ioctl+0x70/0x310
     __x64_sys_ioctl+0x7b/0xc0
     do_syscall_64+0xb6/0xfc0
     entry_SYSCALL_64_after_hwframe+0x4b/0x53

Here is a trivial reproducer that works with the PPS_CLIENT_KTIMER test
device enabled in the kernel:

    #include <stdlib.h>
    #include <fcntl.h>
    #include <unistd.h>
    #include <sys/ioctl.h>
    #include <linux/pps.h>
    #include <err.h>

    int main() {
        struct pps_fdata fdata;
        int fd;

        fd = open("/dev/pps0", O_RDWR);
        if (fd == -1)
            err(1, "Failed to open /dev/pps0");

        fdata.timeout.sec = -1;
        fdata.timeout.nsec = 0;

        if (ioctl(fd, PPS_FETCH, &fdata))
            err(2, "PPS_FETCH failed");

        close(fd);
        return 0;
    }

Sashiko imagines this to be some sort of security problem, which is
obviously really silly.  But I think it is still worth fixing, so buggy
userspace code can't trigger the splat.

Silence the splat by using timespec64_to_jiffies(), which hard limits the
timeout to LONG_MAX jiffies.  To be safe, explicitly preserve the
-ETIMEDOUT return value userspace sees today if it passes a negative
timeout.

If you really squint, this is still a slight behavior change in that there
are "denormalized" combinations of tv_sec and tv_nsec which used to work
but will now return -ETIMEDOUT.  I can't imagine anybody will care about
that...

Link: https://lore.kernel.org/c5c97c3b3c9d66010382094fd538e59a38f4aacf.1781289959.git.calvin@wbinvd.org
Fixes: eae9d2ba0cfc ("LinuxPPS: core support")
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1779733602.git.calvin%40wbinvd.org?part=3
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/pps.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/pps/pps.c~pps-dont-try-to-wait-for-negative-timeouts-in-pps_fetch
+++ a/drivers/pps/pps.c
@@ -66,13 +66,19 @@ static int pps_cdev_pps_fetch(struct pps
 		err = wait_event_interruptible(pps->queue,
 				ev != pps->last_ev);
 	else {
+		struct timespec64 ts;
 		unsigned long ticks;
 
 		dev_dbg(&pps->dev, "timeout %lld.%09d\n",
 				(long long) fdata->timeout.sec,
 				fdata->timeout.nsec);
-		ticks = fdata->timeout.sec * HZ;
-		ticks += fdata->timeout.nsec / (NSEC_PER_SEC / HZ);
+
+		if (fdata->timeout.sec < 0)
+			return -ETIMEDOUT;
+
+		ts.tv_sec = fdata->timeout.sec;
+		ts.tv_nsec = fdata->timeout.nsec;
+		ticks = timespec64_to_jiffies(&ts);
 
 		if (ticks != 0) {
 			err = wait_event_interruptible_timeout(
_

Patches currently in -mm which might be from calvin@wbinvd.org are


