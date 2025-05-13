Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBE01EEA46
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119303; cv=none; b=o0LSkdyFIHDS4gOtzFq/qN0uS+iNUOzIgcdCp9Tv4mJqy8KVKmOTruEsprLFFUmOxgKWhB1l5dka2kwE4eP58lR1FFnlpAL/IpY/ZgY33GgAlzx2QOlUtRM8lFckCFmOnv7AgLSU1J0G4f5GWyVRhZlRw27wSHQXYNmO24yPYCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119303; c=relaxed/simple;
	bh=UyTlWr95hS/mTzXrrfI4+iL3vn3rTYosqV7lEoEImIY=;
	h=Date:To:From:Subject:Message-Id; b=ZH49klSTNAVemCY8Kdsq9wdb0UJ84sdLOe14rfcXaiomQl6UCKAo00p/FH/+4yw8OSeGeznacWoQV1+qJfKhHfOg96CeHTmXN1lFBYmyBSPn5R7wMqa9w+BnlVXry2Hpf9TOF/IXV5AQom7l/KbcyZOwcWi2CgJY8Tv1+eUQtzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YRITHb9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YRITHb9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DBCC4CEE4;
	Tue, 13 May 2025 06:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119303;
	bh=UyTlWr95hS/mTzXrrfI4+iL3vn3rTYosqV7lEoEImIY=;
	h=Date:To:From:Subject:From;
	b=YRITHb9mE5b6LM5dXRRO2HT2g1SNRs9dt55MCfM6L3QRfEh4ryWFsKZ9CGj5nC0HY
	 AopTnNxQ84mC+OwosjW2q5unn577HEAQMDLlrgcAk/mI262hEuMAlDhK0AnX/Q+oRf
	 KqlrOlx0tYBBfdo5dSi9S9/1qKaygc9twNP7m11k=
Date: Mon, 12 May 2025 23:55:02 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,catalin.marinas@arm.com,luizcap@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-drop-wrong-comment.patch removed from -mm tree
Message-Id: <20250513065503.11DBCC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmemleak: drop wrong comment
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-drop-wrong-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


