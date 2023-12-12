Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A9E7F56F
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eG664R/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0F4C433C8;
	Tue, 12 Dec 2023 18:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407553;
	bh=PFVe5CmETX53ZtaW9Qyqy+S54uZFO8osxJYkfDWkyYk=;
	h=Date:To:From:Subject:From;
	b=eG664R/lUfhhmsPzko6P6yLCAmqouG5EH1KgGoh3uOgndIrafwhkmBLGQZWImC6E7
	 gN4bGBOLj2B9GDZwhjg+lNzsLVE10LD8Vi3LY3fiqY09AAnKbd3Kio3vAHTpyBOWi9
	 fBVnyPsySkioxXMokjVbtt13PFVcbfjPZU24FZ/M=
Date: Tue, 12 Dec 2023 10:59:13 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,dan.carpenter@linaro.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-avoid-ascending-when-mas-min-is-also-the-parents-minimum.patch removed from -mm tree
Message-Id: <20231212185913.BC0F4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: avoid ascending when mas->min is also the parent's minimum
has been removed from the -mm tree.  Its filename was
     maple_tree-avoid-ascending-when-mas-min-is-also-the-parents-minimum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: avoid ascending when mas->min is also the parent's minimum
Date: Mon, 20 Nov 2023 15:09:34 +0800

When the child node is the first child of its parent node, mas->min does
not need to be updated. This can reduce the number of ascending times
in some cases.

Link: https://lkml.kernel.org/r/20231120070937.35481-3-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/lib/maple_tree.c~maple_tree-avoid-ascending-when-mas-min-is-also-the-parents-minimum
+++ a/lib/maple_tree.c
@@ -1088,14 +1088,16 @@ static int mas_ascend(struct ma_state *m
 		return 0;
 	}
 
-	if (!mas->min)
+	min = 0;
+	max = ULONG_MAX;
+	if (!mas->offset) {
+		min = mas->min;
 		set_min = true;
+	}
 
 	if (mas->max == ULONG_MAX)
 		set_max = true;
 
-	min = 0;
-	max = ULONG_MAX;
 	do {
 		p_enode = a_enode;
 		a_type = mas_parent_type(mas, p_enode);
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


