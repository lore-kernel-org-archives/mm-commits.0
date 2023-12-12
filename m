Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5354F7F56F
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TH0YqNJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F81C433C7;
	Tue, 12 Dec 2023 18:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407552;
	bh=Rd1s2BBAMwUUgnddZOqhZVIkHcIEEAqkMsd468ADLog=;
	h=Date:To:From:Subject:From;
	b=TH0YqNJqRXvch35h2OAb/LpyO1tZAsZZq0jXvr9HI9pwR/i04zEynWBrj7/okBQgd
	 0shPxL377b8FRMtEkA8sDUnmN09o9m9lNgrPL6wtBuiXP4ONVvk4S5s9/wTTK0oZI9
	 gk2/ou1af8jeImzaFqMlD5+5CEZTviLATwLeOKos=
Date: Tue, 12 Dec 2023 10:59:12 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,dan.carpenter@linaro.org,zhangpeng.00@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch removed from -mm tree
Message-Id: <20231212185912.C8F81C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: move the check forward to avoid static check warning
has been removed from the -mm tree.  Its filename was
     maple_tree-move-the-check-forward-to-avoid-static-check-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: move the check forward to avoid static check warning
Date: Mon, 20 Nov 2023 15:09:33 +0800

Patch series "Some cleanups of maple tree", v2.

These are some small cleanups of maple tree.


This patch (of 5):

Put the check for gap before its reference to avoid Smatch static check
warnings.  This is not a bug, it's just a validation program.  Even with
this change, Smatch may still generate warnings because MT_BUG_ON()
doesn't necessarily stop the program.  It may require fixing Smatch itself
to avoid these warnings.

Link: https://lkml.kernel.org/r/20231120070937.35481-1-zhangpeng.00@bytedance.com
Link: https://lkml.kernel.org/r/20231120070937.35481-2-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: http://lists.infradead.org/pipermail/maple-tree/2023-November/003046.html
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-move-the-check-forward-to-avoid-static-check-warning
+++ a/lib/maple_tree.c
@@ -7257,6 +7257,7 @@ static void mas_validate_gaps(struct ma_
 
 counted:
 	if (mt == maple_arange_64) {
+		MT_BUG_ON(mas->tree, !gaps);
 		offset = ma_meta_gap(node, mt);
 		if (offset > i) {
 			pr_err("gap offset %p[%u] is invalid\n", node, offset);
@@ -7269,7 +7270,6 @@ counted:
 			MT_BUG_ON(mas->tree, 1);
 		}
 
-		MT_BUG_ON(mas->tree, !gaps);
 		for (i++ ; i < mt_slot_count(mte); i++) {
 			if (gaps[i] != 0) {
 				pr_err("gap %p[%u] beyond node limit != 0\n",
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are


