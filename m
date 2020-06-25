From: akpm@linux-foundation.org
Subject: + scripts-decode_stacktrace-skip-missing-symbols.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 22:29:18 -0700
Message-ID: <20200625052918.2imLo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbgFYF3T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 01:29:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sashal@kernel.org, khlebnikov@yandex-team.ru


The patch titled
     Subject: scripts/decode_stacktrace.sh: skip missing symbols
has been added to the -mm tree.  Its filename is
     scripts-decode_stacktrace-skip-missing-symbols.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-decode_stacktrace-skip-missing-symbols.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-decode_stacktrace-skip-missing-symbols.patch

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
Subject: scripts/decode_stacktrace.sh: skip missing symbols

For now script turns missing symbols into '0' and make bogus decode.  Skip
them instead.  Also simplify parsing output of 'nm'.

Before:

$ echo 'xxx+0x0/0x0' | ./scripts/decode_stacktrace.sh vmlinux ""
xxx (home/khlebnikov/src/linux/./arch/x86/include/asm/processor.h:398)

After:

$ echo 'xxx+0x0/0x0' | ./scripts/decode_stacktrace.sh vmlinux ""
xxx+0x0/0x0

Link: http://lkml.kernel.org/r/159282922499.248444.4883465570858385250.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktrace-skip-missing-symbols
+++ a/scripts/decode_stacktrace.sh
@@ -56,7 +56,11 @@ parse_symbol() {
 	if [[ "${cache[$module,$name]+isset}" == "isset" ]]; then
 		local base_addr=${cache[$module,$name]}
 	else
-		local base_addr=$(nm "$objfile" | grep -i ' t ' | awk "/ $name\$/ {print \$1}" | head -n1)
+		local base_addr=$(nm "$objfile" | awk '$3 == "'$name'" && ($2 == "t" || $2 == "T") {print $1; exit}')
+		if [[ $base_addr == "" ]] ; then
+			# address not found
+			return
+		fi
 		cache[$module,$name]="$base_addr"
 	fi
 	# Let's start doing the math to get the exact address into the
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

scripts-decode_stacktrace-skip-missing-symbols.patch
scripts-decode_stacktrace-guess-basepath-if-not-specified.patch
scripts-decode_stacktrace-guess-path-to-modules.patch
scripts-decode_stacktrace-guess-path-to-vmlinux-by-release-name.patch
kernel-watchdog-flush-all-printk-nmi-buffers-when-hardlockup-detected.patch
