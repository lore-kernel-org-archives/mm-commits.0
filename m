Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F125224AEF
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 19:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746126717; cv=none; b=OOlOvomhp2XLgKi3pimekx/ShoxRqprfUnhLX6Gi7WAkHUhwVy31I7bm8yTCn818YBQwuaz6NqL2u6erkX934P6mxQMXm0VgZFpJOQyU2DqDzGvlWNJ1Y2eCmnscr8svJK0baqcfVeWlIyLeyIwZ8r/U0E+04Mjtk1urJkh1E5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746126717; c=relaxed/simple;
	bh=FdisLVpOJcPb5xC2nZIYj+BGGGZuKA7TDFVwzYogKGA=;
	h=Date:To:From:Subject:Message-Id; b=Zfx4fbxbbwEzAt1va1N2812YjB1nio7GP/lxIXNU0eNv/GzNR6py2jgO+CxJASM8giZG6ELX8yvMjDhrNTeIP4WUfqG4P2JJqrd9po7m9olI0viHY/sf3AmZCd0wuErjH6mtJfIhWkBGBJVj9Nvsbii+zfNRtm5y3COhfkmAJfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z4/EMHjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z4/EMHjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F355AC4CEE3;
	Thu,  1 May 2025 19:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746126717;
	bh=FdisLVpOJcPb5xC2nZIYj+BGGGZuKA7TDFVwzYogKGA=;
	h=Date:To:From:Subject:From;
	b=Z4/EMHjWgHRBy1oQXr1tQ90HEHRRubavy7AfXWqwRpdHHhHFNKjHvzfd1eS2ljYPe
	 jTWJXSMn5rThcjNf10k+AgnqDeZbuvsP0dGxmnEPF/bGLAedMRbocN2iAauX0D+CDn
	 eDg0L0ZB1mQ6E1kRP2hL316CExC4u1alsxt7nCaM=
Date: Thu, 01 May 2025 12:11:56 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,catalin.marinas@arm.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-drop-wrong-comment.patch added to mm-unstable branch
Message-Id: <20250501191156.F355AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: drop wrong comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmemleak-drop-wrong-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-drop-wrong-comment.patch

This patch will later appear in the mm-unstable branch at
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
From: Luiz Capitulino <luizcap@redhat.com>
Subject: mm: kmemleak: drop wrong comment
Date: Wed, 30 Apr 2025 16:59:46 -0400

Newly created objects have object->count == 0, so the comment is
incorrect.  Just drop it.

Link: https://lkml.kernel.org/r/3dfd09bc0e77bb626619184a808774ff07de275c.1746046744.git.luizcap@redhat.com
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-drop-wrong-comment
+++ a/mm/kmemleak.c
@@ -322,8 +322,6 @@ static void hex_dump_object(struct seq_f
  *		sufficient references to it (count >= min_count)
  * - black - ignore, it doesn't contain references (e.g. text section)
  *		(min_count == -1). No function defined for this color.
- * Newly created objects don't have any color assigned (object->count == -1)
- * before the next memory scan when they become white.
  */
 static bool color_white(const struct kmemleak_object *object)
 {
_

Patches currently in -mm which might be from luizcap@redhat.com are

mm-kmemleak-drop-kmemleak_warning-variable.patch
mm-kmemleak-drop-wrong-comment.patch
mm-kmemleak-mark-variables-as-__read_mostly.patch

