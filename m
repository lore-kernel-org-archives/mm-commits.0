From: akpm@linux-foundation.org
Subject: +
 scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch added
 to -mm tree
Date: Wed, 24 Jun 2020 22:29:24 -0700
Message-ID: <20200625052924.48NrC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389816AbgFYF3Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 01:29:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sashal@kernel.org, khlebnikov@yandex-team.ru


The patch titled
     Subject: scripts/decode_stacktrace.sh: guess path to vmlinux by release name
has been added to the -mm tree.  Its filename is
     scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch

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
Subject: scripts/decode_stacktrace.sh: guess path to vmlinux by release name

Add option decode_stacktrace -r <release> to specify only release name. 
This is enough to guess standard paths to vmlinux and modules:

$ echo -e 'schedule+0x0/0x0
tap_open+0x0/0x0 [tap]' |
	./scripts/decode_stacktrace.sh -r 5.4.0-37-generic
schedule (kernel/sched/core.c:4138)
tap_open (drivers/net/tap.c:502) tap

Link: http://lkml.kernel.org/r/159282923334.248444.2399153100007347838.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name
+++ a/scripts/decode_stacktrace.sh
@@ -5,14 +5,33 @@
 
 if [[ $# < 1 ]]; then
 	echo "Usage:"
-	echo "	$0 <vmlinux> [base path] [modules path]"
+	echo "	$0 -r <release> | <vmlinux> [base path] [modules path]"
 	exit 1
 fi
 
-vmlinux=$1
-basepath=${2-auto}
-modpath=$3
-release=""
+if [[ $1 == "-r" ]] ; then
+	vmlinux=""
+	basepath="auto"
+	modpath=""
+	release=$2
+
+	for fn in {,/usr/lib/debug}/boot/vmlinux-$release{,.debug} /lib/modules/$release{,/build}/vmlinux ; do
+		if [ -e "$fn" ] ; then
+			vmlinux=$fn
+			break
+		fi
+	done
+
+	if [[ $vmlinux == "" ]] ; then
+		echo "ERROR! vmlinux image for release $release is not found" >&2
+		exit 2
+	fi
+else
+	vmlinux=$1
+	basepath=${2-auto}
+	modpath=$3
+	release=""
+fi
 
 declare -A cache
 declare -A modcache
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

scripts-decode_stacktrace-skip-missing-symbols.patch
scripts-decode_stacktrace-guess-basepath-if-not-specified.patch
scripts-decode_stacktrace-guess-path-to-modules.patch
scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch
kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch
