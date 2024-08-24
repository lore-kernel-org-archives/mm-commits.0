Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B4618EB0
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 05:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724476565; cv=none; b=Phb+rVcKAUwbpJ0ykQv015x8aKpZ+SdqQ/jAk4ItCJQpFMt4S1eiQSSZ/KlplKWC1GuzGvEBblRFbvBHX5a7fbE323xYNdt15p8ueLIoVNJWsLZffkwMLVQp6UHo1zxb0pvmjImAJKsJXimOSMg2kLqcm44frs+KvtyzZ1zEbHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724476565; c=relaxed/simple;
	bh=b9wEOgv6fM3mtJeFTGyF1lzsXUpP6pUadhhKqDd+OsU=;
	h=Date:To:From:Subject:Message-Id; b=sYiuTsSpKdl3w0DiDUxJSqncR93Ji5y2yy+2ypBBgr95+9aMtqb7heiCjIQRjQSoMWQ5C2dP5zzABcmUwNn3NQWRu0/Ct/vfTSq4XWdPzhAxsvlOZp65asecmWb0GCTdwSj1KkenutujM5GT2+tjocQW+oUBfwEBQu/fqqjnZuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MD4kAyQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MD4kAyQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986F3C4AF09;
	Sat, 24 Aug 2024 05:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724476564;
	bh=b9wEOgv6fM3mtJeFTGyF1lzsXUpP6pUadhhKqDd+OsU=;
	h=Date:To:From:Subject:From;
	b=MD4kAyQxUKB9EUnpVoNOufhyjWvK5ka0qgtinwtUJZ6LaRhyTOBrm2hrFUGaukF6M
	 wGl+fYmAtF1dLf7zkVCHGNVvTZezbV2QZL+EthKtDVNWJ1Vrmk8EUWw5r1Ii4f0THu
	 QL0bnIOlZ6UVcHvFjzpU/GlajW4EKHL7JK+Iu+4U=
Date: Fri, 23 Aug 2024 22:16:03 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,richard@nod.at,petr@tesarici.cz,maz@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-fix-gfp-translate-after-___gfp__bits-conversion-to-an-enum.patch added to mm-hotfixes-unstable branch
Message-Id: <20240824051604.986F3C4AF09@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts: fix gfp-translate after ___GFP_*_BITS conversion to an enum
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-fix-gfp-translate-after-___gfp__bits-conversion-to-an-enum.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-fix-gfp-translate-after-___gfp__bits-conversion-to-an-enum.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Marc Zyngier <maz@kernel.org>
Subject: scripts: fix gfp-translate after ___GFP_*_BITS conversion to an enum
Date: Fri, 23 Aug 2024 17:38:50 +0100

Richard reports that since 772dd0342727c ("mm: enumerate all gfp flags"),
gfp-translate is broken, as the bit numbers are implicit, leaving the
shell script unable to extract them.  Even more, some bits are now at a
variable location, making it double extra hard to parse using a simple
shell script.

Use a brute-force approach to the problem by generating a small C stub
that will use the enum to dump the interesting bits.

As an added bonus, we are now able to identify invalid bits for a given
configuration.  As an added drawback, we cannot parse include files that
predate this change anymore.  Tough luck.

Link: https://lkml.kernel.org/r/20240823163850.3791201-1-maz@kernel.org
Fixes: 772dd0342727c ("mm: enumerate all gfp flags")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reported-by: Richard Weinberger <richard@nod.at>
Cc: Petr Tesařík <petr@tesarici.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gfp-translate |   66 +++++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 17 deletions(-)

--- a/scripts/gfp-translate~scripts-fix-gfp-translate-after-___gfp__bits-conversion-to-an-enum
+++ a/scripts/gfp-translate
@@ -62,25 +62,57 @@ if [ "$GFPMASK" = "none" ]; then
 fi
 
 # Extract GFP flags from the kernel source
-TMPFILE=`mktemp -t gfptranslate-XXXXXX` || exit 1
-grep -q ___GFP $SOURCE/include/linux/gfp_types.h
-if [ $? -eq 0 ]; then
-	grep "^#define ___GFP" $SOURCE/include/linux/gfp_types.h | sed -e 's/u$//' | grep -v GFP_BITS > $TMPFILE
-else
-	grep "^#define __GFP" $SOURCE/include/linux/gfp_types.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
-fi
+TMPFILE=`mktemp -t gfptranslate-XXXXXX.c` || exit 1
 
-# Parse the flags
-IFS="
-"
 echo Source: $SOURCE
 echo Parsing: $GFPMASK
-for LINE in `cat $TMPFILE`; do
-	MASK=`echo $LINE | awk '{print $3}'`
-	if [ $(($GFPMASK&$MASK)) -ne 0 ]; then
-		echo $LINE
-	fi
-done
 
-rm -f $TMPFILE
+(
+    cat <<EOF
+#include <stdint.h>
+#include <stdio.h>
+
+// Try to fool compiler.h into not including extra stuff
+#define __ASSEMBLY__	1
+
+#include <generated/autoconf.h>
+#include <linux/gfp_types.h>
+
+static const char *masks[] = {
+EOF
+
+    sed -nEe 's/^[[:space:]]+(___GFP_.*)_BIT,.*$/\1/p' $SOURCE/include/linux/gfp_types.h |
+	while read b; do
+	    cat <<EOF
+#if defined($b) && ($b > 0)
+	[${b}_BIT]	= "$b",
+#endif
+EOF
+	done
+
+    cat <<EOF
+};
+
+int main(int argc, char *argv[])
+{
+	unsigned long long mask = $GFPMASK;
+
+	for (int i = 0; i < sizeof(mask) * 8; i++) {
+		unsigned long long bit = 1ULL << i;
+		if (mask & bit)
+			printf("\t%-25s0x%llx\n",
+			       (i < ___GFP_LAST_BIT && masks[i]) ?
+					masks[i] : "*** INVALID ***",
+			       bit);
+	}
+
+	return 0;
+}
+EOF
+) > $TMPFILE
+
+${CC:-gcc} -Wall -o ${TMPFILE}.bin -I $SOURCE/include $TMPFILE && ${TMPFILE}.bin
+
+rm -f $TMPFILE ${TMPFILE}.bin
+
 exit 0
_

Patches currently in -mm which might be from maz@kernel.org are

scripts-fix-gfp-translate-after-___gfp__bits-conversion-to-an-enum.patch

