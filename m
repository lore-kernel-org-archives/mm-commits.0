From: akpm@osdl.org
Subject: + profile-likely-unlikely-macros-x86_64-fix.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:27:35 -0800
Message-ID: <200701022227.l02MRaHU031947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:39249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964996AbXABWbN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:31:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com, johnstul@us.ibm.com


The patch titled
     profile-likely-unlikely-macros x86_64 fix
has been added to the -mm tree.  Its filename is
     profile-likely-unlikely-macros-x86_64-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: profile-likely-unlikely-macros x86_64 fix
From: Daniel Walker <dwalker@mvista.com>

On Sun, 2006-12-31 at 23:04 +0800, Fengguang Wu wrote:
> Hi,
>
> The following messages keeps popping up when CONFIG_PROFILE_LIKELY=y:
>
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
> init[1]: segfault at ffffffff8118c110 rip ffffffff8118c110 rsp 00007fff9a9d14d8 error 15
>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Acked-by: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/vsyscall.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/kernel/vsyscall.c~profile-likely-unlikely-macros-x86_64-fix arch/x86_64/kernel/vsyscall.c
--- a/arch/x86_64/kernel/vsyscall.c~profile-likely-unlikely-macros-x86_64-fix
+++ a/arch/x86_64/kernel/vsyscall.c
@@ -111,7 +111,7 @@ static __always_inline void do_vgettimeo
 		seq = read_seqbegin(&__vsyscall_gtod_data.lock);
 
 		vread = __vsyscall_gtod_data.clock.vread;
-		if (unlikely(!__vsyscall_gtod_data.sysctl_enabled || !vread)) {
+		if (!__vsyscall_gtod_data.sysctl_enabled || !vread) {
 			gettimeofday(tv,0);
 			return;
 		}
@@ -151,7 +151,7 @@ int __vsyscall(0) vgettimeofday(struct t
  * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
-	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
+	if (!__vsyscall_gtod_data.sysctl_enabled)
 		return time_syscall(t);
 	else if (t)
 		*t = __vsyscall_gtod_data.wall_time_tv.tv_sec;
_

Patches currently in -mm which might be from dwalker@mvista.com are

fix-for-crash-in-adummy_init.patch
panic-on-slim-selinux.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch
profile-likely-unlikely-macros_remove-likely-profiling-int-cast.patch
profile-likely-unlikely-macros-x86_64-fix.patch
