Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F0019DFAB
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 00:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766276751; cv=none; b=eFe/2VCOma4GgPHIZ1swVde0bfQg8vLj5+EDaoa1vpHci6PXWghIcerqAsBHTkd7UF6r4H54aWdvqVAA9Zhsq4Ai42jrdPRtcmpbcdGFgfMRuDTvWqx/E5GPo2mM7oyqx32hTg83LBgSS+YDcUKzxGslMUQ60rLrz8SoRSXk5r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766276751; c=relaxed/simple;
	bh=y/bj3DxOF9HwOS9+blrMm3CMoufJbagtH8kUgdBV0dc=;
	h=Date:To:From:Subject:Message-Id; b=dWkNkBfGaUdEsdkJjUzx1Ysne6MKADo608ae0AoIL0cxkFQ+R33iq2D0psEzN5fDbrsQI/KXqREx20ToYePtQfuQ0vhfML9aHQt3AMAWNAuTRPvXz76petaS0jgPypJwiksB11elYBRcH03FtuwsHmKI8X5tAYZHh+y/0VtqgKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g8zlkpOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g8zlkpOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2BCC4CEF5;
	Sun, 21 Dec 2025 00:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766276750;
	bh=y/bj3DxOF9HwOS9+blrMm3CMoufJbagtH8kUgdBV0dc=;
	h=Date:To:From:Subject:From;
	b=g8zlkpOLxP4fdpAUu+44MKXjmH5amLYhey7vaV2IALNQE1/zQaK0OFNyKzs1SSzVF
	 U3ne7UOcT7HX0tS+iWkaw9Sz/l/hsizCpIqfX+xftUwRkxsbGBTNRMX5HBKRnrveJ8
	 K93/JDDwOLuCGSAiGGrVH//F0FPP4bgl/k2GcDW8=
Date: Sat, 20 Dec 2025 16:25:50 -0800
To: mm-commits@vger.kernel.org,tgraf@suug.ch,davem@davemloft.net,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + textsearch-describe-list-member-in-ts_ops-search.patch added to mm-hotfixes-unstable branch
Message-Id: <20251221002550.DA2BCC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: textsearch: describe @list member in ts_ops search
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     textsearch-describe-list-member-in-ts_ops-search.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/textsearch-describe-list-member-in-ts_ops-search.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: textsearch: describe @list member in ts_ops search
Date: Fri, 19 Dec 2025 08:40:05 +0700

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/textsearch.h:49 struct member 'list' not described in 'ts_ops'

Describe @list member to fix it.

Link: https://lkml.kernel.org/r/20251219014006.16328-4-bagasdotme@gmail.com
Fixes: 2de4ff7bd658c9 ("[LIB]: Textsearch infrastructure.")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/textsearch.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/textsearch.h~textsearch-describe-list-member-in-ts_ops-search
+++ a/include/linux/textsearch.h
@@ -35,6 +35,7 @@ struct ts_state
  * @get_pattern: return head of pattern
  * @get_pattern_len: return length of pattern
  * @owner: module reference to algorithm
+ * @list: list to search
  */
 struct ts_ops
 {
_

Patches currently in -mm which might be from bagasdotme@gmail.com are

mm-describe-flags-parameter-in-memalloc_flags_save.patch
textsearch-describe-list-member-in-ts_ops-search.patch
mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name.patch
mm-kfence-describe-slab-parameter-in-__kfence_obj_info.patch

