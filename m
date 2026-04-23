Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B652E35B64F
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 16:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776960926; cv=none; b=DihOJ/VzqRTOxCzOFy4b+EIbMfExf3L7ym8aWe9hVlGpghIPdl/wFZ2sbdEN+v/5B92EJislykUTjvULFOTSsmoi4WiS9jNzuys0EX/jmXIikw1QleAfh/4Ujm02ZfKDdYzN9SCbtZd9GrEDUS3qqbcm0/sWsFJcd29Bg4nTX78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776960926; c=relaxed/simple;
	bh=6vIg42dbTFTxmYYikLt8KeWyINnbYZVjduJ2vmDYm90=;
	h=Date:To:From:Subject:Message-Id; b=Goa6Lvd8uvtMcPy4EVn9sYGtVEigqDB7hVLYNEy0M+mMPhMlQ5b1IP7Lkky0cXb6NS2DW/TuQh6BKzrjvoC8Dpi2IgQljoPrNL3h9fP8jnRwJJKoYNJz1EQTqG9o1/5nmFOspo3CX3YGqJ7fk2nSdXyvbrzLDIz8xXTE1JtJFc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v6kWDdGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v6kWDdGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4276DC2BCAF;
	Thu, 23 Apr 2026 16:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776960926;
	bh=6vIg42dbTFTxmYYikLt8KeWyINnbYZVjduJ2vmDYm90=;
	h=Date:To:From:Subject:From;
	b=v6kWDdGdRMw7byoQ+QrLY86+iw1ZuzffxKLJmaZY12sbxglaDbkRI0z7zSUARRKTA
	 S6er6Z3MBvDHGUWFcSgptFUioZUYWKxBUVff2SdV/XEi2phDGb4KKemUXlwwAAgtcX
	 pM/l7fauz/Dke6kybNxqQWLPipI1wRnA9buBJKsY=
Date: Thu, 23 Apr 2026 09:15:25 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,fan.yu9@zte.com.cn,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-accounting-getdelays-fix-wformat-truncation-warning-in-format_timespec.patch added to mm-nonmm-unstable branch
Message-Id: <20260423161526.4276DC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/accounting/getdelays: fix -Wformat-truncation warning in format_timespec
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-accounting-getdelays-fix-wformat-truncation-warning-in-format_timespec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-accounting-getdelays-fix-wformat-truncation-warning-in-format_timespec.patch

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
From: Yiyang Chen <cyyzero16@gmail.com>
Subject: tools/accounting/getdelays: fix -Wformat-truncation warning in format_timespec
Date: Thu, 23 Apr 2026 23:11:39 +0800

Reproduce with GCC 13.3.0:

  $ cd tools/accounting
  $ make

This emits:

getdelays.c: In function `format_timespec':
getdelays.c:218:67: warning: `:' directive output may be truncated writing 1 byte into a region of size between 0 and 16 [-Wformat-truncation=]
  218 |         snprintf(buffer, sizeof(buffer), "%04d-%02d-%02dT%02d:%02d:%02d",
      |
getdelays.c:218:9: note: `snprintf' output between 20 and 72 bytes into a destination of size 32

The problem is that %04d and %02d specify minimum field widths only. GCC
cannot prove that formatting tm_year + 1900 and the other struct tm
fields will always fit in the fixed 32-byte buffer, so it warns about
possible truncation.

Fix this by replacing the manual snprintf() formatting with
strftime("%Y-%m-%dT%H:%M:%S", ...). That matches the data we already have
in struct tm, keeps the intended timestamp format, and avoids the warning
when building tools/accounting with GCC.

Link: https://lore.kernel.org/87d9723e0b59d816ee2e4bd7cddd58a54c6c9f91.1776956545.git.cyyzero16@gmail.com
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/accounting/getdelays.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/tools/accounting/getdelays.c~tools-accounting-getdelays-fix-wformat-truncation-warning-in-format_timespec
+++ a/tools/accounting/getdelays.c
@@ -241,13 +241,7 @@ static const char *format_timespec(struc
 	if (localtime_r(&time_sec, &tm_info) == NULL)
 		return "N/A";
 
-	snprintf(buffer, sizeof(buffer), "%04d-%02d-%02dT%02d:%02d:%02d",
-		tm_info.tm_year + 1900,
-		tm_info.tm_mon + 1,
-		tm_info.tm_mday,
-		tm_info.tm_hour,
-		tm_info.tm_min,
-		tm_info.tm_sec);
+	strftime(buffer, sizeof(buffer), "%Y-%m-%dT%H:%M:%S", &tm_info);
 
 	return buffer;
 }
_

Patches currently in -mm which might be from cyyzero16@gmail.com are

tools-accounting-getdelays-fix-wformat-truncation-warning-in-format_timespec.patch

