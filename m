Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCACDF78
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337162; cv=none; b=FQTGpoNvCVq4NTiRx8VOw+cu7gOmOZNjrdw9jHk2r3u2kHY+PO1NN9j+o8IVog2zoEdL36+A3CxcCfPw90iXU3cvnRYDM1bOsjr6X0vIUsOCe+8S7OL+pZcD36yAkBzv/N4VAjQ5tcci9Xst+7cjCcFEn3ZtkHT32EhQXknI+tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337162; c=relaxed/simple;
	bh=l6KJ7znxF+X83/mIW9hG9Q85F4laOiMee4nF5Q/GOkw=;
	h=Date:To:From:Subject:Message-Id; b=lgyRwX+sx/PgnWPiAqfBH1B5DcmI0SJx2yINTWvuM8rJyrCyJDYL2dEnwA0NQc8+rEqu935ZUvxz4xGbrgGtxq9BWB4yubTp0doKwYSqsO33vYwZz8T0VttY98BngRR3svhllc6ZEKy2ctkPQozCct61drnTFQIzOzTGGHNLfHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OGzVDeJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OGzVDeJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7454C4CED6;
	Mon, 20 Jan 2025 01:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337162;
	bh=l6KJ7znxF+X83/mIW9hG9Q85F4laOiMee4nF5Q/GOkw=;
	h=Date:To:From:Subject:From;
	b=OGzVDeJQFJ3KX37U/Ar/CMQvyKjr17Kt0UD5iYOpH2AsjvmplSLFu0uDtRc10y6n8
	 AGEYlWjz2A25a/OQFIdsXgPST5xFfY3ugo885vaMlwtgJxKDRv/CnB/tNG/wyT1Qda
	 +8l/mbxBE8cTXPAvczWEjs4Bm9iPNgDV3q3dYqSs=
Date: Sun, 19 Jan 2025 17:39:21 -0800
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,anshuman.khandual@arm.com,andreyknvl@gmail.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch removed from -mm tree
Message-Id: <20250120013921.E7454C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: hw_tags: Use str_on_off() helper in kasan_init_hw_tags()
has been removed from the -mm tree.  Its filename was
     kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: kasan: hw_tags: Use str_on_off() helper in kasan_init_hw_tags()
Date: Tue, 14 Jan 2025 16:09:35 +0100

Remove hard-coded strings by using the str_on_off() helper function.

Link: https://lkml.kernel.org/r/20250114150935.780869-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/hw_tags.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/kasan/hw_tags.c~kasan-hw_tags-use-str_on_off-helper-in-kasan_init_hw_tags
+++ a/mm/kasan/hw_tags.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/static_key.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <linux/types.h>
 #include <linux/vmalloc.h>
 
@@ -263,8 +264,8 @@ void __init kasan_init_hw_tags(void)
 
 	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
 		kasan_mode_info(),
-		kasan_vmalloc_enabled() ? "on" : "off",
-		kasan_stack_collection_enabled() ? "on" : "off");
+		str_on_off(kasan_vmalloc_enabled()),
+		str_on_off(kasan_stack_collection_enabled()));
 }
 
 #ifdef CONFIG_KASAN_VMALLOC
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

ocfs2-use-str_yes_no-and-str_no_yes-helper-functions.patch

