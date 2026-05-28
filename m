Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B47C348C61;
	Thu, 28 May 2026 19:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779995755; cv=none; b=WZMaPz3oQ3+W6b1PaBZrz6CsKuC6NMqh+X7miVxrvLAxwuY2dUH4EwWYrJ/o858jqKUWa9BkOGiPCbdpDO3fhNrqTDQiXsG2Lu9jwkFmEb3GqqOxJG7S3Hzl1boQUJ9RJxhcoIQrc1Nxa6WSLcPjpu+mDMI6Wjwwz0yAOlXD6BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779995755; c=relaxed/simple;
	bh=nBLSRdY+ODEyGChV5l/yQbEiAqjN9SMLZt7yWnzO+kE=;
	h=Date:To:From:Subject:Message-Id; b=q51SQKuiNhjbmG4FMSMlEJC1TJ7rUZpH51POLj2507wTLTy6apjrLVKuxhIMurey4sn3fKUE+qOIdNEXGozAbdJ1N38mOuUKhSiAdNJtEo2feJ4w0bAAYrRd9rKY1VrAOzqzlpXXNZCKfdj6BQxyWKJbqQtgGFAfOk+wDP+eCj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=acooBV6+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="acooBV6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF261F00A3A;
	Thu, 28 May 2026 19:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779995754;
	bh=j5AX/cP5GkyP5EDqZ/nohpXOtT5YIPTXO+HQweXFIgc=;
	h=Date:To:From:Subject;
	b=acooBV6+IXgYb81XfbFtEUyNxl7DAEmtU33CVGQ6fsZQUh26oQtW+6VV9vIUVAooK
	 6NAepGagFNfdaWA94yoPv7L6Z3uXPxXxoOfScSr1XeQ0vOXa7AERty7A4TEwa0ofNX
	 OQjGHdmoGmVTWJAxodmZXfaxvbZkArJie+P8BLzY=
Date: Thu, 28 May 2026 12:15:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-mm-slabinfo-fix-trace-disable-logic-inversion.patch removed from -mm tree
Message-Id: <20260528191554.1CF261F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/slabinfo: fix trace disable logic inversion
has been removed from the -mm tree.  Its filename was
     tools-mm-slabinfo-fix-trace-disable-logic-inversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: tools/mm/slabinfo: fix trace disable logic inversion
Date: Mon, 18 May 2026 14:21:57 +0800

Patch series "Cleanup and fix tools/mm/slabinfo utility", v2.

This series fixes one bug and cleans up two code quality issues in
tools/mm/slabinfo:

1. Fix trace disable logic inversion: when the user intends to disable
   tracing (!tracing) and it is currently enabled (s->trace),
   set_obj() was called with 1 instead of 0, which is opposite to
   the intended behavior. All other options (sanity_checks, red_zone,
   poison, store_user) in the same function use 0 for the disable
   case.

2. Remove dead assignment in get_obj_and_str(): `x = NULL` sets the
   local parameter variable instead of `*x`, which is a no-op since
   `*x` was already set to NULL on the line above.

3. Remove redundant slab->partial assignment in read_slab_dir():
   slab->partial is assigned by get_obj("partial") and then
   immediately overwritten by get_obj_and_str("partial", &t).


This patch (of 3):

The disable trace path in slab_debug() had a logic error where it would
set trace=1 instead of trace=0.  This made trace functionality permanently
enabled once turned on for any slab cache.

Link: https://lore.kernel.org/20260518062159.80664-1-wangxuewen@kylinos.cn
Link: https://lore.kernel.org/20260518062159.80664-2-wangxuewen@kylinos.cn
Fixes: a87615b8f9e2 ("SLUB: slabinfo upgrade")
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/slabinfo.c~tools-mm-slabinfo-fix-trace-disable-logic-inversion
+++ a/tools/mm/slabinfo.c
@@ -798,7 +798,7 @@ static void slab_debug(struct slabinfo *
 			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
 	}
 	if (!tracing && s->trace)
-		set_obj(s, "trace", 1);
+		set_obj(s, "trace", 0);
 }
 
 static void totals(void)
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are

mm-memory-failure-replace-magic-number-3-with-get_page_max_retry_num.patch
tools-mm-slabinfo-remove-dead-assignment-in-get_obj_and_str.patch
tools-mm-slabinfo-remove-redundant-slab-partial-assignment.patch

