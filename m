From: akpm@linux-foundation.org
Subject: [merged]
 coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:16 -0700
Message-ID: <543d699c.na+1BIF6rsjR2xDq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaJNSVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jan.kratochvil@redhat.com, mjw@redhat.com, mmilata@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: add %i/%I in core_pattern to report the tid of the crashed thread
has been removed from the -mm tree.  Its filename was
     coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: add %i/%I in core_pattern to report the tid of the crashed thread

format_corename() can only pass the leader's pid to the core handler, but
there is no simple way to figure out which thread originated the coredump.

As Jan explains, this also means that there is no simple way to create the
backtrace of the crashed process:

As programs are mostly compiled with implicit gcc -fomit-frame-pointer one
needs program's .eh_frame section (equivalently PT_GNU_EH_FRAME segment)
or .debug_frame section.  .debug_frame usually is present only in separate
debug info files usually not even installed on the system.  While
.eh_frame is a part of the executable/library (and it is even always
mapped for C++ exceptions unwinding) it no longer has to be present
anywhere on the disk as the program could be upgraded in the meantime and
the running instance has its executable file already unlinked from disk.

One possibility is to echo 0x3f >/proc/*/coredump_filter and dump all the
file-backed memory including the executable's .eh_frame section.  But that
can create huge core files, for example even due to mmapped data files.

Other possibility would be to read .eh_frame from /proc/PID/mem at the
core_pattern handler time of the core dump.  For the backtrace one needs
to read the register state first which can be done from core_pattern
handler:

	ptrace(PTRACE_SEIZE, tid, 0, PTRACE_O_TRACEEXIT)
	close(0);    // close pipe fd to resume the sleeping dumper
	waitpid();   // should report EXIT
	PTRACE_GETREGS or other requests

The remaining problem is how to get the 'tid' value of the crashed thread.
It could be read from the first NT_PRSTATUS note of the core file but
that makes the core_pattern handler complicated.

Unfortunately %t is already used so this patch uses %i/%I.

Automatic Bug Reporting Tool (https://github.com/abrt/abrt/wiki/overview)
is experimenting with this.  It is using the elfutils
(https://fedorahosted.org/elfutils/) unwinder for generating the
backtraces.  Apart from not needing matching executables as mentioned
above, another advantage is that we can get the backtrace without saving
the core (which might be quite large) to disk.

[mmilata@redhat.com: final paragraph of changelog]
Signed-off-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Mark Wielaard <mjw@redhat.com>
Cc: Martin Milata <mmilata@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 ++
 fs/coredump.c                   |    8 ++++++++
 2 files changed, 10 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread
+++ a/Documentation/sysctl/kernel.txt
@@ -190,6 +190,8 @@ core_pattern is used to specify a core d
 	%%	output one '%'
 	%p	pid
 	%P	global pid (init PID namespace)
+	%i	tid
+	%I	global tid (init PID namespace)
 	%u	uid
 	%g	gid
 	%d	dump mode, matches PR_SET_DUMPABLE and
diff -puN fs/coredump.c~coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread fs/coredump.c
--- a/fs/coredump.c~coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread
+++ a/fs/coredump.c
@@ -199,6 +199,14 @@ static int format_corename(struct core_n
 				err = cn_printf(cn, "%d",
 					      task_tgid_nr(current));
 				break;
+			case 'i':
+				err = cn_printf(cn, "%d",
+					      task_pid_vnr(current));
+				break;
+			case 'I':
+				err = cn_printf(cn, "%d",
+					      task_pid_nr(current));
+				break;
 			/* uid */
 			case 'u':
 				err = cn_printf(cn, "%d", cred->uid);
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch

