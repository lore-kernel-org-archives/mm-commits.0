Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3532B4A0F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 00:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238784; cv=none; b=J3jW57ZrEhQ2GNe9aWjqcOfbFkEziO9YdNvxw/up8RKj1Q5T4FZN3Wgt2TRa/vUMdzKhHLWWWxogCfceLeTUFtAZKnlqAq3dQXXeWptgYBvmjUa6IgzbCaM61703H2tI6Q1dxbHYuelg6KFkzkET/RSbmmwPqfIR2pGXM8JYZwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238784; c=relaxed/simple;
	bh=DEJHXVdZwhXyGGT0l46YnXs3u6P1soV1EjTHfEZIVD0=;
	h=Date:To:From:Subject:Message-Id; b=azemUJ5rg8lwuDwiJdEyeR9nkQbr1/a7YHw1ZQfAv12cudLIZ2nl6oAnGcpYcAVN8FAF4+Kmr4lSK9LqG8g+nr0e3tf6598Us5eR47regr7hFxexkX9WV1U/7kCa1J7JywduI63zK/kmJZ+zx4RKYecB94TJ9wkeiJ1+KrTc3YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wd37+rK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wd37+rK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08913C4CEC3;
	Mon,  2 Sep 2024 00:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238784;
	bh=DEJHXVdZwhXyGGT0l46YnXs3u6P1soV1EjTHfEZIVD0=;
	h=Date:To:From:Subject:From;
	b=wd37+rK4Owy4mIHlYGFiDtzUm8FBV3E2j2axrHXOuWF+hQxvjpvXfXtO9rVY0UW6M
	 sb/8zU2n6BP5JukkyDEipgcZlDQnZ+M5OeHzGKOz0Lwvm3qLFE9oj6XPfElBVI+hql
	 SW9O/0l0vME2Logl2xEapOheNTd785Rkr2D9nh1A=
Date: Sun, 01 Sep 2024 17:59:43 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,richard@nod.at,petr@tesarici.cz,maz@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-fix-gfp-translate-after-___gfp__bits-conversion-to-an-enum.patch removed from -mm tree
Message-Id: <20240902005944.08913C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts: fix gfp-translate after ___GFP_*_BITS conversion to an enum
has been removed from the -mm tree.  Its filename was
     scripts-fix-gfp-translate-after-___gfp__bits-conversion-to-an-enum.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 772dd0342727 ("mm: enumerate all gfp flags")
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


