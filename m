Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC0B1A9F83
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 22:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789166224; cv=none; b=m9L64AH8n0XYo9OL7/oZ6GUcLPSuuJMYaPVl78EawEa8Hor0RohOUJG1K/uukcldaameqmRpdoiaTZbt0mE/rrLIB7DJjGfOrVzWZAyx+rQd/V1YeZ6f8vgypra3wxm05soUoK/tDg2xpWFBDyEdD1GzzUtbD5nN3/G3yo6kPGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789166224; c=relaxed/simple;
	bh=VA47QZewyCGrZZtusjtFLQBHlfT1xuYen3faPG+2r60=;
	h=Date:To:From:Subject:Message-Id; b=uEbO7RmPl3cpmWltif5dTeBrRmPYCpBGxczb6ByCFlqvYjNVJpySz6PuXV3lELKxPlp3VotyAnGw32Jj2Q9WZWipQG8/iMJrfPpG6X3CNWj4g81XfJXETLa6MLLA4tZ3DoXibcLK6u10Ehzd3rxGVkW5lrhmGCphGuqEtyhHyVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v7hvUxEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v7hvUxEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F11D1F000FF;
	Fri, 11 Sep 2026 22:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789166223;
	bh=0R9Ke/z1kR3c9k8q7rv0RCgK+LcBjj0W25LqfqdLQvk=;
	h=Date:To:From:Subject;
	b=v7hvUxEBWsQ918+sAbJIINfa6QBKV6FHFENo1OkOZYeU/MX8ty5j0z9ONPtfmvBcK
	 nqISns8UTZq/MJgqUvEGNUGq5oPDLckWncYyL8iWPDhDZ4orsQuMWgzSW36RTRH6Bj
	 c4ljdzEC8IhJx+JifG5ruFb7XKFg0LHUUUy3v4SM=
Date: Fri, 11 Sep 2026 15:37:02 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] bootconfig-reject-unexpected-data-after-null-character.patch removed from -mm tree
Message-Id: <20260911223703.4F11D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: reject unexpected data after null character
has been removed from the -mm tree.  Its filename was
     bootconfig-reject-unexpected-data-after-null-character.patch

This patch was dropped because an updated version will be issued

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
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
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

tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch
tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch
bootconfig-fix-integer-overflow-in-initrd-size-check.patch

