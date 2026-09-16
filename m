Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0804E431C;
	Wed, 16 Sep 2026 23:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601458; cv=none; b=MKritWz6yLq898BH3vILHzBPt/sPc0e5iKwTlnhQk/xeHHzmpJvKWPj2amWqG20FX4XkTB2Ez4KD0fwQs9Ck6L4GZuPRxoE47AJaTcyIlKUp4WIUHkPfF+yx2Y0MeiA83AlMyPzjG0zppmhkZjj/NCNJ04Nq8oiT3kDgL8XBIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601458; c=relaxed/simple;
	bh=/bzOFe/Kmzkm59iMBjGGsDiJVZmDfSJpNeZ94G1o/o8=;
	h=Date:To:From:Subject:Message-Id; b=sUurFUyCsgr92tNyiz9UflFkZjLS1LHWbqhnrjcFhK3DZ088lXgxmyzLrOExJTJBDUQAcbDgZiqEsJ1D2fsI4h7n0eLmsgRYHHHcX3pA0AQLeOoDq8yf7fPF13tnCZmwfS58ZR2K54D+AJI8nvDhxSLlt5oTNvAfWhDkIIle5MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j/Qu02tI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j/Qu02tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711131F000FF;
	Wed, 16 Sep 2026 23:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789601455;
	bh=zfQXXBkSExk3RxxeKgyFQpLPFGREpmjuUl3vFHV7DLY=;
	h=Date:To:From:Subject;
	b=j/Qu02tI1r2azRHTSLjFc0G9G+988Sv5rAN/vyvF4fqg5J4h/PkA28a4Ahdf0TjeF
	 k5EuY397W+84znRDqYBTy/y8HAW+cPISVrlT3ZNRSAynnF1gyLA7aIkVo0vpk19kCX
	 TfGLd7Xbak0sY2GDTijPcvWGBUQLN31XjhZg90dA=
Date: Wed, 16 Sep 2026 16:30:55 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-avoid-false-positive-wuninitialized-warning-again.patch added to mm-hotfixes-unstable branch
Message-Id: <20260916233055.711131F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: avoid false-positive -Wuninitialized warning, again
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmscan-avoid-false-positive-wuninitialized-warning-again.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-avoid-false-positive-wuninitialized-warning-again.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/vmscan: avoid false-positive -Wuninitialized warning, again
Date: Wed, 16 Sep 2026 10:34:46 +0200

I previously worked around a false-postive gcc-16 warning in the
get_tier_idx() function, by adding a fake initializer. This happens with
the -fsanitize=bounds sanitizer when the compiler creates a specialized
variant of isolate_folios():

In function 'get_tier_idx',
    inlined from 'isolate_folios.constprop' at mm/vmscan.c:4982:9:
mm/vmscan.c:4934:9: error: 'sp.refaulted' is used uninitialized [-Werror=uninitialized]
 4934 |         read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mm/vmscan.c: In function 'isolate_folios.constprop':
mm/vmscan.c:4946:25: note: 'sp.refaulted' was declared here
 4946 |         struct ctrl_pos sp, pv = {};
      |                         ^~

Adding another "= {}" would solve the problem as well, but to prevent
this from happening again after the next code refactoring, try instead to
prevent this by forbidding interprocedural optimizations on this function.

Link: https://lore.kernel.org/all/20260213123902.3466040-1-arnd@kernel.org/
Link: https://lore.kernel.org/20260916083456.4136132-1-arnd@kernel.org
Fixes: 3de705a43a46 ("mm/vmscan: avoid false-positive -Wuninitialized warning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/vmscan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-avoid-false-positive-wuninitialized-warning-again
+++ a/mm/vmscan.c
@@ -3195,8 +3195,12 @@ struct ctrl_pos {
 	int gain;
 };
 
-static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
-			  struct ctrl_pos *pos)
+/*
+ * __noipa works around  gcc-16 warning for uninitialized use of
+ * pos->refaulted
+ */
+static __noipa void read_ctrl_pos(struct lruvec *lruvec, int type, int tier,
+			  int gain, struct ctrl_pos *pos)
 {
 	int i;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -4802,7 +4806,7 @@ static int scan_folios(unsigned long nr_
 static int get_tier_idx(struct lruvec *lruvec, int type)
 {
 	int tier;
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	/*
 	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
@@ -4821,7 +4825,7 @@ static int get_tier_idx(struct lruvec *l
 
 static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
 {
-	struct ctrl_pos sp, pv = {};
+	struct ctrl_pos sp, pv;
 
 	if (swappiness <= MIN_SWAPPINESS + 1)
 		return LRU_GEN_FILE;
_

Patches currently in -mm which might be from arnd@arndb.de are

alloc_tag-avoid-implicit-padding-in-uapi.patch
mm-vmscan-avoid-false-positive-wuninitialized-warning-again.patch

