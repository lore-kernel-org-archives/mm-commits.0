From: akpm@linux-foundation.org
Subject: +
 scripts-decode_stacktrace-guess-basepath-if-not-specified.patch added to -mm
 tree
Date: Wed, 24 Jun 2020 22:29:20 -0700
Message-ID: <20200625052920.ddfYO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbgFYF3V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 01:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sashal@kernel.org, khlebnikov@yandex-team.ru


The patch titled
     Subject: scripts/decode_stacktrace.sh: guess basepath if not specified
has been added to the -mm tree.  Its filename is
     scripts-decode_stacktrace-guess-basepath-if-not-specified.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-decode_stacktrace-guess-basepath-if-not-specified.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-decode_stacktrace-guess-basepath-if-not-specified.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: scripts/decode_stacktrace.sh: guess basepath if not specified

Guess path to kernel sources using known location of symbol "kernel_init".
Make basepath argument optional.

Before:

$ echo 'vfs_open+0x0/0x0' | ./scripts/decode_stacktrace.sh vmlinux ""
vfs_open (home/khlebnikov/src/linux/fs/open.c:912)

After:

$ echo 'vfs_open+0x0/0x0' | ./scripts/decode_stacktrace.sh vmlinux
vfs_open (fs/open.c:912)

Link: http://lkml.kernel.org/r/159282922803.248444.2379229451667913634.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-guess-basepath-if-not-specified
+++ a/scripts/decode_stacktrace.sh
@@ -3,14 +3,14 @@
 # (c) 2014, Sasha Levin <sasha.levin@oracle.com>
 #set -x
 
-if [[ $# < 2 ]]; then
+if [[ $# < 1 ]]; then
 	echo "Usage:"
-	echo "	$0 [vmlinux] [base path] [modules path]"
+	echo "	$0 <vmlinux> [base path] [modules path]"
 	exit 1
 fi
 
 vmlinux=$1
-basepath=$2
+basepath=${2-auto}
 modpath=$3
 declare -A cache
 declare -A modcache
@@ -152,6 +152,14 @@ handle_line() {
 	echo "${words[@]}" "$symbol $module"
 }
 
+if [[ $basepath == "auto" ]] ; then
+	module=""
+	symbol="kernel_init+0x0/0x0"
+	parse_symbol
+	basepath=${symbol#kernel_init (}
+	basepath=${basepath%/init/main.c:*)}
+fi
+
 while read line; do
 	# Let's see if we have an address in the line
 	if [[ $line =~ \[\<([^]]+)\>\] ]] ||
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

scripts-decode_stacktrace-skip-missing-symbols.patch
scripts-decode_stacktrace-guess-basepath-if-not-specified.patch
scripts-decode_stacktrace-guess-path-to-modules.patch
scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch
kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch
