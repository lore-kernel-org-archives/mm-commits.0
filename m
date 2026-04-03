Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B060736607C
	for <mm-commits@vger.kernel.org>; Fri,  3 Apr 2026 06:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775196852; cv=none; b=SMyybW+O3oaHE6TXIpVdw4VWxCdOrKNDncHeScvxXPe3OybGIhKTt02KsmYuHw73U9O+qHEf7wIAlx4qIfZIsbUJ2F9d6LkM6i5IkIi4A5AXbOoI0JmBt2wX0z2hx09w/zqlNd4MTtcTclN7Lo4DM+H08DwyvS+uYYOvzfNaLHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775196852; c=relaxed/simple;
	bh=STbKrsqUIFL0gwCoyjNSTB8SKlwxmm4pdO60MapVZNs=;
	h=Date:To:From:Subject:Message-Id; b=H2gCR/TTg2iiUCloA1QFFd50wmxcQWF8YZzozYV0X7/D0hmeBXW2iPEPcAOmeBDLqtsrKVluVpqs4oYl1HtTnuZl2FaRMjmta+SLdu+onQNTgdWDN+uOI8cBeGXlDaaxzbrYfozbNFXdFR8okgvftPbjaQJ6PcuIBPeWhJxtc7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iK7y5bzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iK7y5bzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6768CC4CEF7;
	Fri,  3 Apr 2026 06:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775196851;
	bh=STbKrsqUIFL0gwCoyjNSTB8SKlwxmm4pdO60MapVZNs=;
	h=Date:To:From:Subject:From;
	b=iK7y5bzOspI8eOr9iPT4+lKojdFNCuD1j8onxhKysy7OgQNv7MUEIjG0YmvuYARVD
	 Q8kQnTgQK+OfKi2s8v2zXmwbDbdnavN7zlhm40qOpDWiHMOw0zgjHPREpH7i1Udlg+
	 zU0U4uH/L/qzESwOOzby8cOo8HhAn9FQsIHpgJLE=
Date: Thu, 02 Apr 2026 23:14:10 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch removed from -mm tree
Message-Id: <20260403061411.6768CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix
has been removed from the -mm tree.  Its filename was
     lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

This patch was dropped because it was folded into lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix
Date: Fri Mar 20 06:19:29 PM PDT 2026

remove now-unused local

Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/list_sort.c~lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix
+++ a/lib/list_sort.c
@@ -50,7 +50,6 @@ static void merge_final(void *priv, list
 			struct list_head *a, struct list_head *b)
 {
 	struct list_head *tail = head;
-	u8 count = 0;
 
 	for (;;) {
 		/* if equal, take 'a' -- important for sort stability */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final.patch

