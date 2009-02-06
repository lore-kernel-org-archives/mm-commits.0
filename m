From: akpm@linux-foundation.org
Subject: + kernel-doc-fix-syscall-wrapper-processing.patch added to -mm tree
Date: Fri, 06 Feb 2009 13:06:47 -0800
Message-ID: <200902062106.n16L6lXn002118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbZBFVHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 16:07:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: fix syscall wrapper processing
has been added to the -mm tree.  Its filename is
     kernel-doc-fix-syscall-wrapper-processing.patch

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
Subject: kernel-doc: fix syscall wrapper processing
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc processing of SYSCALL wrappers.

The SYSCALL wrapper patches played havoc with kernel-doc for
syscalls.  Syscalls that were scanned for DocBook processing
reported warnings like this one, for sys_tgkill:

Warning(kernel/signal.c:2285): No description found for parameter 'tgkill'
Warning(kernel/signal.c:2285): No description found for parameter 'pid_t'
Warning(kernel/signal.c:2285): No description found for parameter 'int'

because the macro parameters all "look like" function parameters,
although they are not:

/**
 *  sys_tgkill - send signal to one specific thread
 *  @tgid: the thread group ID of the thread
 *  @pid: the PID of the thread
 *  @sig: signal to be sent
 *
 *  This syscall also checks the @tgid and returns -ESRCH even if the PID
 *  exists but it's not belonging to the target process anymore. This
 *  method solves the problem of threads exiting and PIDs getting reused.
 */
SYSCALL_DEFINE3(tgkill, pid_t, tgid, pid_t, pid, int, sig)
{
...

This patch special-cases the handling SYSCALL_DEFINE* function
prototypes by expanding them to
	long sys_foobar(type1 arg1, type1 arg2, ...)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-fix-syscall-wrapper-processing scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-fix-syscall-wrapper-processing
+++ a/scripts/kernel-doc
@@ -1827,6 +1827,40 @@ sub reset_state {
     $state = 0;
 }
 
+sub syscall_munge() {
+	my $void = 0;
+
+	$prototype =~ s@[\r\n\t]+@ @gos; # strip newlines/CR's/tabs
+##	if ($prototype =~ m/SYSCALL_DEFINE0\s*\(\s*(a-zA-Z0-9_)*\s*\)/) {
+	if ($prototype =~ m/SYSCALL_DEFINE0/) {
+		$void = 1;
+##		$prototype = "long sys_$1(void)";
+	}
+
+	$prototype =~ s/SYSCALL_DEFINE.*\(/long sys_/; # fix return type & func name
+	if ($prototype =~ m/long (sys_.*?),/) {
+		$prototype =~ s/,/\(/;
+	} elsif ($void) {
+		$prototype =~ s/\)/\(void\)/;
+	}
+
+	# now delete all of the odd-number commas in $prototype
+	# so that arg types & arg names don't have a comma between them
+	my $count = 0;
+	my $len = length($prototype);
+	if ($void) {
+		$len = 0;	# skip the for-loop
+	}
+	for (my $ix = 0; $ix < $len; $ix++) {
+		if (substr($prototype, $ix, 1) eq ',') {
+			$count++;
+			if ($count % 2 == 1) {
+				substr($prototype, $ix, 1) = ' ';
+			}
+		}
+	}
+}
+
 sub process_state3_function($$) {
     my $x = shift;
     my $file = shift;
@@ -1839,11 +1873,15 @@ sub process_state3_function($$) {
     elsif ($x =~ /([^\{]*)/) {
 	$prototype .= $1;
     }
+
     if (($x =~ /\{/) || ($x =~ /\#\s*define/) || ($x =~ /;/)) {
 	$prototype =~ s@/\*.*?\*/@@gos;	# strip comments.
 	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/cr's.
 	$prototype =~ s@^\s+@@gos; # strip leading spaces
-	dump_function($prototype,$file);
+	if ($prototype =~ /SYSCALL_DEFINE/) {
+		syscall_munge();
+	}
+	dump_function($prototype, $file);
 	reset_state();
     }
 }
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
kernel-doc-preferred-ending-marker-and-examples.patch
kernel-doc-fix-syscall-wrapper-processing.patch
linux-next.patch
uv-fix-header-struct-usage.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver-dont-use-bus_id.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch

