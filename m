Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F094825B6
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 23:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788997562; cv=none; b=CtKcFpRueClBwuaNuNSeack+e8ZXxR4COon/rsWeS8LO9Dc6NdZccXhUX/HeuixtAk26qyZlszKZViVPAdYNj4K6O5BZ3DaLFqZVFCT/lXzgYfZFSm5KUvlxLZrGXjYzvMN6cagXPWCUL+8oBYmAIjptjJAwDZ4bi8B/sTMOyj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788997562; c=relaxed/simple;
	bh=YXbhg1DHwn9VWNvDxw21Y24Ou+jWHOAiqH1v1C4a9xU=;
	h=Date:To:From:Subject:Message-Id; b=P/3nsHdWe9ETb0HGRfW9qz2Ctjv3TWBZcFRTDFDO63CgAaEsd9abTH2APaE8X6+c5fOkjwGutyR1CCB7Xu1+06/pFB/sNZe0NAvpirwc0GQh5tbFXhWYFDHAS0yqbUEfb9p0uao9WJXp8DtwyoyrrefPIO9Bpj8y6rgTaTmVIFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A0Cz1tg7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A0Cz1tg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D101F000FF;
	Wed,  9 Sep 2026 23:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788997561;
	bh=XEpm0oyWQiZZsEQgfrpdbnnySTorOeoCKoY/cYgdG9g=;
	h=Date:To:From:Subject;
	b=A0Cz1tg7FIFNbmaHrD/IS4wpLwOQk9TT8xi83J5mdpTrvVsQoIgNK7tv0zknYCjNV
	 DLW1YkieDvhboqrf4dXILLS70/ZXETSNTwxeZgaxNF/c744jwpiQC9wVGoGUUWla4x
	 4Ba2R9ss+JehM+amdFjGS7+Y2DP+A57ncz/6x5lA=
Date: Wed, 09 Sep 2026 16:46:00 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootconfig-reject-unexpected-data-after-null-character.patch added to mm-nonmm-unstable branch
Message-Id: <20260909234601.30D101F000FF@smtp.kernel.org>
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
Date: Thu, 10 Sep 2026 00:53:45 +0900

Patch series "bootconfig: Reject unexpected data after null character and
cleanups".

Patches for bootconfig to reject unexpected config data after null
character and other cleanups including tools/bootconfig to consolidate
bootconfig initialization with errors, and skipping internal tree sanity
checks in kernel.


This patch (of 3):

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
Link: https://lore.kernel.org/178896921555.177508.434402948295885560.stgit@devnote2
Link: https://lore.kernel.org/178896922501.177508.6894964926791268965.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bootconfig.c                    |    7 +++++++
 tools/bootconfig/main.c             |    4 +++-
 tools/bootconfig/test-bootconfig.sh |   12 ++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

--- a/lib/bootconfig.c~bootconfig-reject-unexpected-data-after-null-character
+++ a/lib/bootconfig.c
@@ -1119,6 +1119,13 @@ static int __init xbc_parse_tree(void)
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
@@ -422,7 +422,9 @@ static int apply_xbc(const char *path, c
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

bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

