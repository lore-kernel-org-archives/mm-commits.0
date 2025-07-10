Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F93B286420
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126360; cv=none; b=Oq7zBup+GfCqSwUz3tsASXW+uav2F92Ci10kxH+ANU21L6DlHe7B41WyKYxqVjbFL71zDPJM5Z9tiUZQymqLm8d+9DHJ3I5EnFacuvOrDfIZp4MrRYRJ4L5sgjufHCvQJ8Q709xobnaPmncDXYBmqTY/VZoQPIcvmcS6Vh04vio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126360; c=relaxed/simple;
	bh=GdbsCUPMFPA615towYhgLBIIsr02zkwIVRqgRb9iEtc=;
	h=Date:To:From:Subject:Message-Id; b=aUqXNuZSA+qBLvMiPXInOmSxC7jY4Iw1F6hXJk6LoJFegbKxxGKZNEy5FQDCM/48M9D7J3t/5UsOhJI4KsiEpYQ//yJqfJXGEsvJEF6LbQbi7kAZxIzTXe6DhG28O4SMb3MUo6C9/GdterHGdaoZXu8n3Wpc7PEzDOlUYm9oL9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lxa7/tFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lxa7/tFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10CCC4CEF4;
	Thu, 10 Jul 2025 05:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126360;
	bh=GdbsCUPMFPA615towYhgLBIIsr02zkwIVRqgRb9iEtc=;
	h=Date:To:From:Subject:From;
	b=lxa7/tFB/8YxOgt4WAFVnx38wNRZFwUXk5oeOfcZ/rUAs7OxeaAy1rt1rBkt/vEkn
	 GtZwYZv2gH2zA0yvWuAt8md+2xJh/1QIsFR6Sc+nlYDCx9AS43J7YJMLVHS0P6+VJa
	 hdAqPOh6I3YcHbBN6yciL6LfPbqzwLBYN4N7Q32g=
Date: Wed, 09 Jul 2025 22:45:59 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple-tree-use-goto-label-to-simplify-code.patch removed from -mm tree
Message-Id: <20250710054559.E10CCC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple tree: use goto label to simplify code
has been removed from the -mm tree.  Its filename was
     maple-tree-use-goto-label-to-simplify-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: maple tree: use goto label to simplify code
Date: Tue, 24 Jun 2025 13:37:48 +0530

Use the underflow goto label to set the status to ma_underflow and return
NULL, as is being done elsewhere.

[akpm@linux-foundation.org: add newline, per Liam (and remove one, per akpm)]
Link: https://lkml.kernel.org/r/20250624080748.4855-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/lib/maple_tree.c~maple-tree-use-goto-label-to-simplify-code
+++ a/lib/maple_tree.c
@@ -4560,15 +4560,12 @@ again:
 	if (unlikely(mas_rewalk_if_dead(mas, node, save_point)))
 		goto retry;
 
-
 	if (likely(entry))
 		return entry;
 
 	if (!empty) {
-		if (mas->index <= min) {
-			mas->status = ma_underflow;
-			return NULL;
-		}
+		if (mas->index <= min)
+			goto underflow;
 
 		goto again;
 	}
_

Patches currently in -mm which might be from dev.jain@arm.com are

maple-tree-add-some-comments.patch
khugepaged-reduce-race-probability-between-migration-and-khugepaged.patch
khugepaged-generalize-alloc_charge_folio.patch

