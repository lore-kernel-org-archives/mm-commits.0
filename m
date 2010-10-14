From: akpm@linux-foundation.org
Subject: + scripts-namespacepl-improve-to-get-more-correct-results.patch added to -mm tree
Date: Thu, 14 Oct 2010 15:56:36 -0700
Message-ID: <201010142256.o9EMuawU024306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab0JNW5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 18:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, mmarek@suse.cz, shemminger@vyatta.com


The patch titled
     scripts/namespace.pl: improve to get more correct results
has been added to the -mm tree.  Its filename is
     scripts-namespacepl-improve-to-get-more-correct-results.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/namespace.pl: improve to get more correct results
From: Amerigo Wang <amwang@redhat.com>

Exclude more symbols from arch/x86/vdso/ and arch/x86/boot/; add some more
linker-defined symbols into exception list; add other cond_syscalls
besides "sys_*".

Signed-off-by: Amerigo Wang <amwang@redhat.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/namespace.pl |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN scripts/namespace.pl~scripts-namespacepl-improve-to-get-more-correct-results scripts/namespace.pl
--- a/scripts/namespace.pl~scripts-namespacepl-improve-to-get-more-correct-results
+++ a/scripts/namespace.pl
@@ -133,6 +133,12 @@ my %nameexception = (
     '__nosave_begin'	=> 1,
     '__nosave_end'	=> 1,
     'pg0'		=> 1,
+    'vdso_enabled'	=> 1,
+    '__stack_chk_fail'  => 1,
+    'VDSO32_PRELINK'	=> 1,
+    'VDSO32_vsyscall'	=> 1,
+    'VDSO32_rt_sigreturn'=>1,
+    'VDSO32_sigreturn'	=> 1,
 );
 
 
@@ -157,7 +163,8 @@ sub linux_objects
 	if (/.*\.o$/ &&
 		! (
 		m:/built-in.o$:
-		|| m:arch/x86/kernel/vsyscall-syms.o$:
+		|| m:arch/x86/vdso/:
+		|| m:arch/x86/boot/:
 		|| m:arch/ia64/ia32/ia32.o$:
 		|| m:arch/ia64/kernel/gate-syms.o$:
 		|| m:arch/ia64/lib/__divdi3.o$:
@@ -200,6 +207,7 @@ sub linux_objects
 		|| m:^.*/\.tmp_:
 		|| m:^\.tmp_:
 		|| m:/vmlinux-obj.o$:
+		|| m:^tools/:
 		)
 	) {
 		do_nm($basename, $_);
@@ -355,20 +363,15 @@ sub list_multiply_defined
 	foreach my $name (keys(%def)) {
 		if ($#{$def{$name}} > 0) {
 			# Special case for cond_syscall
-			if ($#{$def{$name}} == 1 && $name =~ /^sys_/) {
+			if ($#{$def{$name}} == 1 &&
+			   ($name =~ /^sys_/ || $name =~ /^compat_sys_/ ||
+			    $name =~ /^sys32_/)) {
 				if($def{$name}[0] eq "kernel/sys_ni.o" ||
 				   $def{$name}[1] eq "kernel/sys_ni.o") {
 					&drop_def("kernel/sys_ni.o", $name);
 					next;
 				}
 			}
-			# Special case for i386 entry code
-			if ($#{$def{$name}} == 1 && $name =~ /^__kernel_/ &&
-			    $def{$name}[0] eq "arch/x86/kernel/vsyscall-int80_32.o" &&
-			    $def{$name}[1] eq "arch/x86/kernel/vsyscall-sysenter_32.o") {
-				&drop_def("arch/x86/kernel/vsyscall-sysenter_32.o", $name);
-				next;
-			}
 
 			printf "$name is multiply defined in :-\n";
 			foreach my $module (@{$def{$name}}) {
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
scripts-namespacepl-fix-wrong-source-path.patch
scripts-namespacepl-update-file-exclusion-list.patch
scripts-namespacepl-some-bug-fixes.patch
scripts-namespacepl-improve-to-get-more-correct-results.patch
scripts-namespacepl-add-source-file-location-exceptions.patch
maintainers-remove-usb-ov511-driver.patch
maintainers-remove-usb-zc0301-driver.patch

