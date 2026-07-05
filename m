Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F1303C97
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 20:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783282829; cv=none; b=WhiPtKOOJjPGVODon/x83PPtSniuN4bcqfVD+6F7R5jMsDWIfjoBus9VK1Z4zR1iEa92zX5vRVSOEzVeOMrvL+mejZnQZZQk6vnJn6uwROPl6QPri0B/877nmPrszbhGQsV6msNlxNQqJQeR6YacLYdedK1BTDD3Nt/BBLjgIvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783282829; c=relaxed/simple;
	bh=g61M817OMuKLOd/HYbAW1avPAmVarVSHI14p4eSiVB0=;
	h=Date:To:From:Subject:Message-Id; b=TbchI0lgKFg15/9T2WM6PcXdR6RUlDCOZf90jWo6tAjWfhmnssGy3P7MuYqRNSEQHmXsxkUvFCVmR7eJVgrhnrxBOsM92OryyhEL3ZzU+o62ny0vMJA0souNPfixIeHIvDf6aA3LaDnMHeHIUJMjOV9HoB1zl/yIMeK5ggWpNXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=abFdCH99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="abFdCH99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1441F000E9;
	Sun,  5 Jul 2026 20:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783282828;
	bh=Phf5j0Rp8e/EeacipnB7H2z9nipK8/6eYPo7WyFjIWY=;
	h=Date:To:From:Subject;
	b=abFdCH99iQWn16cfgXgKNv6LsbIXzzDgt+gEaMDYTKuiuirie5oe8osmMtjUJgEE2
	 AVCkGsSgpXvzgLxa1E6TNm9wlagR1TF4OwPqqRf5ZzQcdyZMi1ppGxL3FPQ6N3Z0eU
	 FQmT6oRzqRshC42eM+8phnhSjPl4azSkMnUdLrKE=
Date: Sun, 05 Jul 2026 13:20:27 -0700
To: mm-commits@vger.kernel.org,sashiko-bot@kernel.org,gregkh@linuxfoundation.org,giometti@enneenne.com,calvin@wbinvd.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + pps-dont-try-to-wait-for-negative-timeouts-in-pps_fetch.patch added to mm-nonmm-unstable branch
Message-Id: <20260705202027.ED1441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: pps: don't try to wait for negative timeouts in PPS_FETCH
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     pps-dont-try-to-wait-for-negative-timeouts-in-pps_fetch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pps-dont-try-to-wait-for-negative-timeouts-in-pps_fetch.patch

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

pps-dont-try-to-wait-for-negative-timeouts-in-pps_fetch.patch
pps-dont-allow-pps_kc_bind-on-removed-devices.patch

