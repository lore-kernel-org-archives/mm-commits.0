Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C2C17A31C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 01:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780710356; cv=none; b=OfBVGDkEczsDub86Q+p1zjQIx+Sluc/j1cgoJMZch5hZDq2LKr/Y2dM+ha3bjc+d+Gp79aZbZDVjswCtiIqiI11va6b/NLMbzHnWknsbAnfxOoxLtvbw/iiHIX9p4ww7exk4OJRIrCmx+yDxNVeZtGuWDvPnkMfie8YKJjd6PdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780710356; c=relaxed/simple;
	bh=hMI2taxPMmEea6veFRAqPaI3Ui+eitOksMfOa+gutyA=;
	h=Date:To:From:Subject:Message-Id; b=I3IE/xrazrCTVhFcolgVJyeWosb/6TL0vWagzClTqUAxgVdh9zIlJgaMb6yw7c8br/lRuHO4ZkAZdEE0JCtSOJ54cH5Mmew63WiLA03OS4Sple2KraN/I0gl/E/Zxv12BZGK9rS0Y5mrCsIk+kAEoZsUi/t1A3DDcFilA/ld9D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OXgpSIw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OXgpSIw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F6B1F00893;
	Sat,  6 Jun 2026 01:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780710355;
	bh=31wQ1ORHztlHLh/1kyBqvwxMEKxmMJutIEjFZOBGW3s=;
	h=Date:To:From:Subject;
	b=OXgpSIw5uh9SbXF31bbAPNO50P3my0cjRFqh0sN6INXBXgdH9HBz/CKgHaYL8j+lL
	 Ym8cwe7ZAnbaUeB6HTO+suz5zxTrfYi5viYXe3NR78IGFipoPjuS2uAFbn2FrTAp2w
	 FcJHrkA39JJLH3CP9BVcLm/HuwJT0nxMNCBGVTq8=
Date: Fri, 05 Jun 2026 18:45:55 -0700
To: mm-commits@vger.kernel.org,scott.branden@broadcom.com,mcgrof@kernel.org,kees@kernel.org,akpm@linux-foundation.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_firmware-allocate-the-configured-into_buf-size.patch added to mm-nonmm-unstable branch
Message-Id: <20260606014555.88F6B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_firmware: allocate the configured into_buf size
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_firmware-allocate-the-configured-into_buf-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_firmware-allocate-the-configured-into_buf-size.patch

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
From: Samuel Moelius <sam.moelius@trailofbits.com>
Subject: lib/test_firmware: allocate the configured into_buf size
Date: Fri, 5 Jun 2026 00:30:37 +0000

The batched into_buf test path allocates TEST_FIRMWARE_BUF_SIZE bytes
unconditionally, but then passes test_fw_config->buf_size to
request_firmware_into_buf() or request_partial_firmware_into_buf().

Userspace can set config_buf_size above TEST_FIRMWARE_BUF_SIZE before
triggering a batched request. If the firmware file is large enough, the
firmware loader writes past the end of the 1 KiB test buffer.

Allocate the buffer with the same size that the test passes to the firmware
API so config_buf_size remains the actual buffer size under test.

Assisted-by: Codex:gpt-5.5-cyber-preview
Link: https://lore.kernel.org/20260605003038.2005840-1-sam.moelius@trailofbits.com
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_firmware.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_firmware.c~lib-test_firmware-allocate-the-configured-into_buf-size
+++ a/lib/test_firmware.c
@@ -867,7 +867,7 @@ static int test_fw_run_batch_request(voi
 	if (test_fw_config->into_buf) {
 		void *test_buf;
 
-		test_buf = kzalloc(TEST_FIRMWARE_BUF_SIZE, GFP_KERNEL);
+		test_buf = kzalloc(test_fw_config->buf_size, GFP_KERNEL);
 		if (!test_buf)
 			return -ENOMEM;
 
_

Patches currently in -mm which might be from sam.moelius@trailofbits.com are

mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch
lib-test_firmware-allocate-the-configured-into_buf-size.patch

