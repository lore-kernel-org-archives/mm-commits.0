Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0203B9DA4
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439053; cv=none; b=Ojhx1OgkYLRI+Klz8+TmBXb+5J9Bvtch8D8puJAUzu+C/pVtYYK5fQGOsP3vUBFMZ5saTkZdB7fqFve07Bz+D6D6IZDMdAhWlLzyuz5KmD1H3DQgTumU8sJc4WUOxfmD8WL6E9L+J4WdWxfAGmQE/rFqycUAPBB60nw24ovRcmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439053; c=relaxed/simple;
	bh=nJQMu6Ra+RHYwy2HobIZ6Fk+bA9qQiawz1rn8vzNv8o=;
	h=Date:To:From:Subject:Message-Id; b=idIAuCVid1+X5pFfDWuRDD6fUzgerOWrrqRIfyrUgniOvcQmIJMXFcSzG478H5cXLH3jfKd7Yxfj9CxjT2EhgUxFVDTG0TOBnT/mPcAEajRkDA7TMJBa/Rr76NkUBu0KVU3b3M2/ai/UKWci6gPsUBvle7aLMb38y9M/I2bHl8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BACnIIm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BACnIIm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A80D1F00898;
	Tue,  2 Jun 2026 22:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439052;
	bh=HX2GwAdrkkImBZp5GRbo9wxTHQKfDMkjgTPfdqmWXg8=;
	h=Date:To:From:Subject;
	b=BACnIIm67NZwmxFs4tCd5tavp8O1ibMckEexQqhsfvGGlsUADqKgG8nIF0KF6jvJb
	 mAWox4DTgYIC8xqTMocygjNgcYOIQYlX1++1FNsM4KbzRTuQqwDNXNUlbIon0+TAiz
	 4LsLcHc0puyGYS53NuhtOcrVKUHQ2/n7p1OzEnl8=
Date: Tue, 02 Jun 2026 15:24:11 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,david@kernel.org,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch removed from -mm tree
Message-Id: <20260602222412.4A80D1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page-types: fix kpageflags option argument in getopt_long
has been removed from the -mm tree.  Its filename was
     tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm/page-types: fix kpageflags option argument in getopt_long
Date: Wed, 13 May 2026 10:21:18 +0800

The --kpageflags option requires an argument to specify the kpageflags
file path, but has_arg was set to 0 (no_argument) in the long options
table.  Change it to 1 (required_argument) so getopt_long correctly parses
the argument.

Link: https://lore.kernel.org/20260513022120.58033-4-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page-types.c~tools-mm-page-types-fix-kpageflags-option-argument-in-getopt_long
+++ a/tools/mm/page-types.c
@@ -1261,7 +1261,7 @@ static const struct option opts[] = {
 	{ "no-summary", 0, NULL, 'N' },
 	{ "hwpoison"  , 0, NULL, 'X' },
 	{ "unpoison"  , 0, NULL, 'x' },
-	{ "kpageflags", 0, NULL, 'F' },
+	{ "kpageflags", 1, NULL, 'F' },
 	{ "help"      , 0, NULL, 'h' },
 	{ NULL        , 0, NULL, 0 }
 };
_

Patches currently in -mm which might be from liuye@kylinos.cn are


