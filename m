From: akpm@linux-foundation.org
Subject: + scripts-tagssh-handle-omap-platforms-properly.patch added to
 -mm tree
Date: Fri, 02 Dec 2016 16:54:28 -0800
Message-ID: <584217c4.gBhZysyE75LA7nMI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753283AbcLCAyN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Dec 2016 19:54:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: semen.protsenko@linaro.org, mmarek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: handle OMAP platforms properly
has been added to the -mm tree.  Its filename is
     scripts-tagssh-handle-omap-platforms-properly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-tagssh-handle-omap-platforms-properly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-tagssh-handle-omap-platforms-properly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: scripts/tags.sh: handle OMAP platforms properly

When SUBARCH is "omap1" or "omap2", plat-omap/ directory must be
indexed. Handle this special case properly.

While at it, check if mach- directory exists at all.

Link: http://lkml.kernel.org/r/20161202122148.15001-1-joe.skb7@gmail.com
Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Michal Marek <mmarek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN scripts/tags.sh~scripts-tagssh-handle-omap-platforms-properly scripts/tags.sh
--- a/scripts/tags.sh~scripts-tagssh-handle-omap-platforms-properly
+++ a/scripts/tags.sh
@@ -304,11 +304,26 @@ if [ "${ARCH}" = "um" ]; then
 elif [ "${SRCARCH}" = "arm" -a "${SUBARCH}" != "" ]; then
 	subarchdir=$(find ${tree}arch/$SRCARCH/ -name "mach-*" -type d -o \
 							-name "plat-*" -type d);
+	mach_suffix=$SUBARCH
+	plat_suffix=$SUBARCH
+
+	# Special cases when $plat_suffix != $mach_suffix
+	case $mach_suffix in
+		"omap1" | "omap2")
+			plat_suffix="omap"
+			;;
+	esac
+
+	if [ ! -d ${tree}arch/$SRCARCH/mach-$mach_suffix ]; then
+		echo "Warning: arch/arm/mach-$mach_suffix/ not found." >&2
+		echo "         Fix your \$SUBARCH appropriately" >&2
+	fi
+
 	for i in $subarchdir; do
 		case "$i" in
-			*"mach-"${SUBARCH})
+			*"mach-"${mach_suffix})
 				;;
-			*"plat-"${SUBARCH})
+			*"plat-"${plat_suffix})
 				;;
 			*)
 				subarchprune="$subarchprune \
_

Patches currently in -mm which might be from semen.protsenko@linaro.org are

scripts-tagssh-handle-omap-platforms-properly.patch

