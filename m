Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F188735838F
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338702; cv=none; b=uBU0oY45cssMr8r8Uz9U3NGHFqbOCu2BK2lKxreAfkhgMuO/rUiQnuEmFp3v2/vK8OxKKv3dZkLtw5PdsCFu0CB4n3QXwGa/maYIcYiKQIRri+pNsyB8ezlCLF0+Qo6Ufx7UzLFRIKA5uAJHHZeWnrdtdHR+pUdvnxCYAUGKmAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338702; c=relaxed/simple;
	bh=Gv8HhmcrBhrEIgrgpuVNARyELfm9w6qjPjFBFVstXRY=;
	h=Date:To:From:Subject:Message-Id; b=Btt6DcCC4ZBcPJ7zYO4sUAm4sF66pHkcL8RRloz3Ead9KVCvMjXR0J0TSLD49bB5LpRIClxuqt6xsIW4YPjJlggUlrdjf/zDFutQHUb/gmy9RKxFBHZ1LxZBt9a3IKk5VKXYwc5StSbKfJ7bToHPbwOsJh2xq++QeBjxYII9nOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K90OMeKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K90OMeKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63161F0089B;
	Wed,  7 Oct 2026 02:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338700;
	bh=OtEOFiv/BnCjfa/rSMHgUQjY22Ng52vc7q2O+PIldC8=;
	h=Date:To:From:Subject;
	b=K90OMeKe17zd9I3RtirXNXpmbZ16hFvdWjhKobC9OxRc/QY5NAmZhDqOWTgVJpj0v
	 +3OZP/QJEe7VvqB+MrMKqPU/Wz98XGSNgZQZQcExq9VR1b4m1bCZBAC4siryE5x2lp
	 IU7t9cQ+WeVeue5VZEB/ZBj5a/AwtzJ2bi+kgD+w=
Date: Tue, 06 Oct 2026 19:05:00 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bootconfig-reject-unexpected-data-after-null-character.patch removed from -mm tree
Message-Id: <20261007020500.C63161F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: reject unexpected data after null character
has been removed from the -mm tree.  Its filename was
     bootconfig-reject-unexpected-data-after-null-character.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/178913597653.248794.1237187523153227751.stgit@devnote2
Link: https://lore.kernel.org/178913598628.248794.1048773774471250986.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Assisted-by: Antigravity:gemini-3.8-flash
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


