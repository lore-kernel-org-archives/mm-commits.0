Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4149A16F265;
	Sun, 20 Jul 2025 02:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752978414; cv=none; b=anj3WFL7MmEwHTy6xHW529uTwKZFTTZs13bDcMoi4l1BMw8huICLogoR4hbCFGqPwUJHktyHdiEAItHeyoQQLdEgip5Vpm2MsKIIYxRpVKFbhqsNGcAzYrin5Tp6lm82UtmFQ8ZsiexVljlKJ8apePTerj3BqYUFCP5nBsx2buY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752978414; c=relaxed/simple;
	bh=ARvBRiVtPOoV66yYuCa+IDRlrdzu0AuvmAt1MXp2ZFo=;
	h=Date:To:From:Subject:Message-Id; b=UB5h9Ps4JyD3iifoqW5K5+H5uaeb1hJ6F/fMmXvko1s0a07Ff74cg6zBko85TriCgsiULWjwAKASc4HfGEcDGAhb0Psc052B/3nRwoJsvbP9Avfp7vnKSGA3cMqwFCIZhrWjJ7pnYj8XlN7VEKL+6cI31CLp8xOI1OTUQlqH0BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H3VQampy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H3VQampy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B115C4CEE3;
	Sun, 20 Jul 2025 02:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752978414;
	bh=ARvBRiVtPOoV66yYuCa+IDRlrdzu0AuvmAt1MXp2ZFo=;
	h=Date:To:From:Subject:From;
	b=H3VQampy6sZW7oBayHx86ydGMA0UYO2u00Yq/9+j2NEBSpuBlJFNy5PyqgRXIFUu8
	 DFKdIYaGa6SBGbZZEMqsMfNhx6nHxp3W2Gc2sCeSaUc3Ho5KuL5Eh+ns6ZlqRsjHmp
	 qio4iDH7WwKqxto8hNK1Rgi2MVJiDoXW8XryGh5U=
Date: Sat, 19 Jul 2025 19:26:53 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,stable@vger.kernel.org,shr@devkernel.io,david@redhat.com,chengming.zhou@linux.dev,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-ksm-fix-wsometimes-uninitialized-from-clang-21-in-advisor_mode_show.patch removed from -mm tree
Message-Id: <20250720022654.0B115C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-wsometimes-uninitialized-from-clang-21-in-advisor_mode_show.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: mm/ksm: fix -Wsometimes-uninitialized from clang-21 in advisor_mode_show()
Date: Tue, 15 Jul 2025 12:56:16 -0700

After a recent change in clang to expose uninitialized warnings from const
variables [1], there is a false positive warning from the if statement in
advisor_mode_show().

  mm/ksm.c:3687:11: error: variable 'output' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
   3687 |         else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
        |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  mm/ksm.c:3690:33: note: uninitialized use occurs here
   3690 |         return sysfs_emit(buf, "%s\n", output);
        |                                        ^~~~~~

Rewrite the if statement to implicitly make KSM_ADVISOR_NONE the else
branch so that it is obvious to the compiler that ksm_advisor can only be
KSM_ADVISOR_NONE or KSM_ADVISOR_SCAN_TIME due to the assignments in
advisor_mode_store().

Link: https://lkml.kernel.org/r/20250715-ksm-fix-clang-21-uninit-warning-v1-1-f443feb4bfc4@kernel.org
Fixes: 66790e9a735b ("mm/ksm: add sysfs knobs for advisor")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2100
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-wsometimes-uninitialized-from-clang-21-in-advisor_mode_show
+++ a/mm/ksm.c
@@ -3669,10 +3669,10 @@ static ssize_t advisor_mode_show(struct
 {
 	const char *output;
 
-	if (ksm_advisor == KSM_ADVISOR_NONE)
-		output = "[none] scan-time";
-	else if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
+	if (ksm_advisor == KSM_ADVISOR_SCAN_TIME)
 		output = "none [scan-time]";
+	else
+		output = "[none] scan-time";
 
 	return sysfs_emit(buf, "%s\n", output);
 }
_

Patches currently in -mm which might be from nathan@kernel.org are


