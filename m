Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600CA370AE0
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027629; cv=none; b=j7DvuFxvh7UacvU9tbQsAWlq2x2V7ULK1qx2AcFTEON3VqfAkOLHmTaXaXq87TZKLM3ju9pd3CBhrTOvoRELsbzkDLuoByt0892OyLvWQ3oZTDe27UICWN88+oawkjqQqWTZe/cO5tpwpCPoBbEi6zLF83DcZF1eQtoTN067bsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027629; c=relaxed/simple;
	bh=bkOmwI0oSHGjUMgOfoj1Twzo2JnK86FgFR8N8IWP3q4=;
	h=Date:To:From:Subject:Message-Id; b=fGBRaAtOW3qzdnD9f7BTADW9NEv0sGduQS1ophqTitF65ACF1u7QhdqGgzeBqJUeWjCo4Yilwu/YuNYfUUp1MLlXy0ZvoN4/Af/omR8BDJX5YAHSx7MsgfPzys6cMenhXzb+D9IZ6Qn86J/2n2fbDhZBsu4fIp27pxpI3r1IyOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sYHzBazC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sYHzBazC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC21A1F00893;
	Fri, 29 May 2026 04:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027626;
	bh=c8BTnjD7+f+c55IHJow/1HU5yJHzVRxKst1FuurlVnY=;
	h=Date:To:From:Subject;
	b=sYHzBazCE1KmDZGwFOPJl7sTadO/kulrinl1CJy9Uva4Yh6yUed699rGdjUy3UlHw
	 UbzLQvbzFPK1DDMJBTadAZJUEd+PgDTruU+q7yJLVeCcbvw3upAGUyHLhth5mEBxEH
	 G+yzkA2dzOXSoA3hs1e7ioLtt3v/mhe4OxKO/FiI=
Date: Thu, 28 May 2026 21:07:06 -0700
To: mm-commits@vger.kernel.org,tzimmermann@suse.de,stf_xl@wp.pl,pabeni@redhat.com,mripard@kernel.org,maarten.lankhorst@linux.intel.com,kuba@kernel.org,horms@kernel.org,glider@google.com,elver@google.com,edumazet@google.com,dvyukov@google.com,davem@davemloft.net,allison.henderson@oracle.com,airlied@gmail.com,achender@kernel.org,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-use-special-gfp_t-format-specifier.patch removed from -mm tree
Message-Id: <20260529040706.BC21A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kfence: use special gfp_t format specifier
has been removed from the -mm tree.  Its filename was
     mm-kfence-use-special-gfp_t-format-specifier.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/kfence: use special gfp_t format specifier
Date: Thu, 26 Mar 2026 12:31:59 +0000

%pGg produces nice readable output and decouples the format string from
the size of gfp_t.

Link: https://lore.kernel.org/20260326-gfp64-v2-3-d916021cecdf@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Allison Collins <allison.henderson@oracle.com>
Cc: Allison Henderson <achender@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Thomas Zimemrmann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/kfence_test.c~mm-kfence-use-special-gfp_t-format-specifier
+++ a/mm/kfence/kfence_test.c
@@ -263,7 +263,7 @@ static void *test_alloc(struct kunit *te
 		break;
 	}
 
-	kunit_info(test, "%s: size=%zu, gfp=%x, policy=%s, cache=%i\n", __func__, size, gfp,
+	kunit_info(test, "%s: size=%zu, gfp=%pGg, policy=%s, cache=%i\n", __func__, size, &gfp,
 		   policy_name, !!test_cache);
 
 	/*
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-introduce-for_each_free_list.patch
mm-page_alloc-dont-overload-migratetype-in-find_suitable_fallback.patch
mm-rejig-pageblock-mask-definitions.patch
mm-page_alloc-remove-ifdefs-from-pindex-helpers.patch
mm-page_alloc-drop-a-misleading-__always_inline.patch
mm-page_alloc-document-that-alloc_pages_nolock-uses-rcu.patch
mm-page_alloc-remove-vm_bug_ons-from-pindex-helpers.patch

