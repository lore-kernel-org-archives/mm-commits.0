Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF63F4AEE2
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 04:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754540480; cv=none; b=Exd0tBcDa4DCtIoc0klC+D0FgVpmnJVkm/W8wvM2uXPrmNbUiLHa/r+kgzEtvLclM0NSzzTn5FVVGdrkfZKNdnsUHv58Wuac7Wj8pNzxUw3wgVSEJ7IXDyzzP9qa6McOKJSMKapi0xXqzY855aBXPZxs5JvoqXes0EkjQDAMQ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754540480; c=relaxed/simple;
	bh=+4Z47dgUGFk5DbtuOvlejj+jyVFUIpBRF9vN5LThru8=;
	h=Date:To:From:Subject:Message-Id; b=ETuBdPTnfurHRCVVK1oa2NjQ7650/3I6DhrvwF3G6bGe3oTVG8yRi68WUDHry1h369RU16BHSgp7fHZoAe7Dc/amDqFT1YsfjrVWjuMHACpsxDAT2W62XS9dhfObufUhoI+LxjsV84YiR3Ec1iLJyS8hv2MUOzpPBR6FCOJwtvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JqE+3qWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JqE+3qWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F44AC4CEEB;
	Thu,  7 Aug 2025 04:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754540480;
	bh=+4Z47dgUGFk5DbtuOvlejj+jyVFUIpBRF9vN5LThru8=;
	h=Date:To:From:Subject:From;
	b=JqE+3qWzV3wzwOB+1SmO/Ms9cBIBbSnL+fbHWoKkuLiDzStk8WiRZiK0WXtCxheGv
	 Z4MHHd/zAJfKcgcSM+fN2PH49+4s/bxTU7dDEi1AqMH0wvcEag0mni/16rEjnmqLGK
	 xGALCQmL4OVxYDqPxvQq/sFCI6D01GSi5PRC2vMw=
Date: Wed, 06 Aug 2025 21:21:19 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nvmem-update-a-comment-related-to-struct-nvmem_config.patch added to mm-nonmm-unstable branch
Message-Id: <20250807042120.4F44AC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nvmem: update a comment related to struct nvmem_config
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nvmem-update-a-comment-related-to-struct-nvmem_config.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nvmem-update-a-comment-related-to-struct-nvmem_config.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: nvmem: update a comment related to struct nvmem_config
Date: Mon, 14 Jul 2025 10:17:10 +0200

Update a comment to match the function used in nvmem_register(). 
ida_simple_get() was replaced by ida_alloc() in commit 1eb51d6a4fce
("nvmem: switch to simpler IDA interface")

Link: https://lkml.kernel.org/r/27a9dec93a9f79140b11a77df38b1b45bd342e09.1752480043.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nvmem-provider.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/nvmem-provider.h~nvmem-update-a-comment-related-to-struct-nvmem_config
+++ a/include/linux/nvmem-provider.h
@@ -103,7 +103,7 @@ struct nvmem_cell_info {
  *
  * Note: A default "nvmem<id>" name will be assigned to the device if
  * no name is specified in its configuration. In such case "<id>" is
- * generated with ida_simple_get() and provided id field is ignored.
+ * generated with ida_alloc() and provided id field is ignored.
  *
  * Note: Specifying name and setting id to -1 implies a unique device
  * whose name is provided as-is (kept unaltered).
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

idr-test-suite-remove-usage-of-the-deprecated-ida_simple_xx-api.patch
ida-remove-the-ida_simple_xxx-api.patch
nvmem-update-a-comment-related-to-struct-nvmem_config.patch

