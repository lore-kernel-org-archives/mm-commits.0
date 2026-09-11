Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99751A9F83
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 22:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789167563; cv=none; b=Wgg5hhZDf/xttexCbC1gj/SXeePtAeJJ3d7fyx2CPKw3Ix/XgTo0DCWfoOts+OP39zTnYYrVoFJzZr5FogZwm6rYjMeHMDszB2K67voPr7NK16unBjRHFgQES7PxvBMWBPhU0dIeAg3qMC0w+kElrcVGaEO8wtrsNH1cixoH5Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789167563; c=relaxed/simple;
	bh=WpycTEGrHvliy6LFSuHhuVFRECNLN5UkBeVf3hoc6os=;
	h=Date:To:From:Subject:Message-Id; b=jcZyE+capCeoDfkvQ3MwvfbIcNcUOZCsN7EkRZx/WatxciVYb0pKDDA5kZTrr3gKt8UhsFTm6ancc8XBKWWXm0B70lasX7FqRYxyXvxCqARCkKls5oR1NSQFtcoWZ1gHLyEPxnsQAIXJUSJtkJef5X0uv2Vs6VL6auWKjKRxxFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HZxZl+Br; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HZxZl+Br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F4C1F000FF;
	Fri, 11 Sep 2026 22:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789167561;
	bh=S7LYjSEA42OY+oRrf5JipDIhoucJ06a1vNBdofq/GB4=;
	h=Date:To:From:Subject;
	b=HZxZl+BrCuiTQH79x3qdWLN3VOLOY4kg4IkXTwCBn9f8bEio3EYMbXn1mFiPl/Bku
	 psXd0pnArfSoYBFn8ZyqUg1/PrprzGZrn03pUmXc4bw2Hcscq0xF9hXgxbuFY14vlQ
	 LgykCW7WyH6ER/VYELgCFYDZdeTQhZvr9ff3eDDk=
Date: Fri, 11 Sep 2026 15:59:20 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootconfig-reject-unexpected-data-after-null-character.patch added to mm-nonmm-unstable branch
Message-Id: <20260911225921.25F4C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootconfig: reject unexpected data after null character
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bootconfig-reject-unexpected-data-after-null-character.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootconfig-reject-unexpected-data-after-null-character.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: bootconfig: reject unexpected data after null character
Date: Fri, 11 Sep 2026 23:13:06 +0900

Patch series "bootconfig: Reject unexpected data after null character and
cleanups", v2.

Make bootconfig reject unexpected config data after null character and
implement other cleanups including tools/bootconfig to consolidate
bootconfig initialization with errors, and to skip internal tree sanity
checks in kernel.


This patch (of 4):

If a bootconfig buffer contains an intermediate null character in the
middle of the configuration, xbc_parse_tree() stops at the null character
because string delimiter searches (e.g.  strpbrk()) stop at '\0', and
cleanly breaks out of the loop without error.  As a result, any
configuration data following the intermediate null character is silently
ignored, allowing unparsed or potentially malicious data to be hidden
after an early termination.

Fix this in xbc_parse_tree() by checking that no non-null data remains
between the parser termination point and the end of the input buffer. 
Trailing null characters (such as alignment padding in initrd) continue to
be accepted as valid.

Also update apply_xbc() in tools/bootconfig/main.c to calculate the buffer
size based on the loaded file size rather than strlen(), so that files
with intermediate null characters are not truncated before validation.

Assisted-by: Antigravity:gemini-3.8-flash
Link: https://lore.kernel.org/178913597653.248794.1237187523153227751.stgit@devnote2
Link: https://lore.kernel.org/178913598628.248794.1048773774471250986.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c                    |    7 +++++++
 tools/bootconfig/main.c             |    4 +++-
 tools/bootconfig/test-bootconfig.sh |   12 ++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

--- a/lib/bootconfig.c~bootconfig-reject-unexpected-data-after-null-character
+++ a/lib/bootconfig.c
@@ -1118,6 +1118,13 @@ static int __init xbc_parse_tree(void)
 		}
 	} while (!ret);
 
+	if (!ret) {
+		while (p < xbc_data + xbc_data_size - 1 && *p == '\0')
+			p++;
+		if (p < xbc_data + xbc_data_size - 1)
+			ret = xbc_parse_error("Unexpected data after null character", p);
+	}
+
 	return ret;
 }
 
--- a/tools/bootconfig/main.c~bootconfig-reject-unexpected-data-after-null-character
+++ a/tools/bootconfig/main.c
@@ -433,7 +433,9 @@ static int apply_xbc(const char *path, c
 		pr_err("Failed to load %s : %d\n", xbc_path, ret);
 		return ret;
 	}
-	size = strlen(buf) + 1;
+	size = ret;
+	if (size == 0 || buf[size - 1] != '\0')
+		size++;
 	csum = xbc_calc_checksum(buf, size);
 
 	/* Backup the bootconfig data */
--- a/tools/bootconfig/test-bootconfig.sh~bootconfig-reject-unexpected-data-after-null-character
+++ a/tools/bootconfig/test-bootconfig.sh
@@ -180,6 +180,18 @@ EOF
 $BOOTCONF -a $TEMPCONF $INITRD 2> $OUTFILE
 xpass grep -q "1:1" $OUTFILE
 
+echo "Intermediate null character test"
+printf "key = value\n\0extra = data\n" > $TEMPCONF
+xfail $BOOTCONF -a $TEMPCONF $INITRD
+$BOOTCONF -a $TEMPCONF $INITRD 2> $OUTFILE
+xpass grep -q "Unexpected" $OUTFILE
+
+echo "Trailing null character test"
+printf "key = value\n\0" > $TEMPCONF
+xpass $BOOTCONF -a $TEMPCONF $INITRD
+$BOOTCONF $INITRD > $OUTFILE
+xpass grep -q "value" $OUTFILE
+
 echo "=== expected failure cases ==="
 for i in samples/bad-* ; do
   xfail $BOOTCONF -a $i $INITRD
_

Patches currently in -mm which might be from mhiramat@kernel.org are

tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch
bootconfig-fix-integer-overflow-in-initrd-size-check.patch
bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch
bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh.patch

