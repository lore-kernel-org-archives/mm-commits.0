Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CB138F97;
	Mon,  4 Nov 2024 06:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730702504; cv=none; b=qNMX2rcRymfkjAsh3iILCnfjZ6Ab2OpxhqI7dlCfZSEjlp2S12k9pEpqy+gFQfrSqBZCBoawtFKFh7EqD7ex6pSF8+NSqnbhD8rbvPYKXPTktC2KV7lIZAp6RoKiB5ukqkOJp0JTIeNYN0v7cdU483JQ3/nxrouXRwlvObwyDGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730702504; c=relaxed/simple;
	bh=1He2WfzU6FKImMj1jNmdnNixPUV0P05HlwgjpDXrenQ=;
	h=Date:To:From:Subject:Message-Id; b=NrIk+uHl0CEGNVGbgINiBG2MFXJQKbJiBh2eKWPtCGeiQkyXnXbuXyLuxXtbsTBrK83BHwNAP5Rz7+9IwZsrvDYZN+zOhQVw9MKAGVXcIDBYPsSOJSfYfVSna468+2CHquJ0ld1wYDck3J4rCMVsak+Q+w73cu6GW5sKOIa+X0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q14VvloV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q14VvloV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1536C4CECE;
	Mon,  4 Nov 2024 06:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730702504;
	bh=1He2WfzU6FKImMj1jNmdnNixPUV0P05HlwgjpDXrenQ=;
	h=Date:To:From:Subject:From;
	b=Q14VvloVySn8Enq6BAwZiap8I/r+8IWMKy503qf3RzODzUFZpB4WUhXGKHpm8Gnm2
	 WYv9q7CqPRclWtgRD3tVA92VolVdKeZ6R6SUeAe6YtMWW+2Dc7K/NdTjDkLNXQ/h7w
	 UsduLKhZX0EcaUFZuURK2xScGxq006/gmpa3uTBE=
Date: Sun, 03 Nov 2024 22:41:43 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,James.Bottomley@HansenPartnership.com,andy@kernel.org,bartosz.golaszewski@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-string_helpers-fix-potential-snprintf-output-truncation.patch removed from -mm tree
Message-Id: <20241104064143.F1536C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: string_helpers: fix potential snprintf() output truncation
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-fix-potential-snprintf-output-truncation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: lib: string_helpers: fix potential snprintf() output truncation
Date: Mon, 21 Oct 2024 11:14:17 +0200

The output of ".%03u" with the unsigned int in range [0, 4294966295] may
get truncated if the target buffer is not 12 bytes.

Link: https://lkml.kernel.org/r/20241021091417.37796-1-brgl@bgdev.pl
Fixes: 3c9f3681d0b4 ("[SCSI] lib: add generic helper to print sizes rounded to the correct SI range")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/string_helpers.c~lib-string_helpers-fix-potential-snprintf-output-truncation
+++ a/lib/string_helpers.c
@@ -57,7 +57,7 @@ int string_get_size(u64 size, u64 blk_si
 	static const unsigned int rounding[] = { 500, 50, 5 };
 	int i = 0, j;
 	u32 remainder = 0, sf_cap;
-	char tmp[8];
+	char tmp[12];
 	const char *unit;
 
 	tmp[0] = '\0';
_

Patches currently in -mm which might be from bartosz.golaszewski@linaro.org are


