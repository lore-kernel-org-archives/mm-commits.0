Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B41813BAD1
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645222; cv=none; b=kfywDJ4SLHquCOFuk3c58piE2Oh4e0Pyaz2Rzja4W+55lUThbdZDGOAt76/7vnkTJdmla8VHrh1qjdwf+/9I4iMZcFPtpVTuqVjlNIytsQO01MKPURwyVPO8axxV5XExRGbO8dYeZf7zRcXFqauF6bVGB9QMddT3Qcf3IyuU6lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645222; c=relaxed/simple;
	bh=6XTdRoqyBbv+NMgyMamw1aMI63j25nzju8K5e+2Qzuc=;
	h=Date:To:From:Subject:Message-Id; b=IVAlStsCP/pDLzWhKOsxUsE1Sd8GJazmpDWxRCKUUjWds3X9ehut1tuTPLbP20KXMdwt3DqnD0KOIJ0ZZmEKlLd/en9leMzZ8LYPdK/HjxEhZTCNwDvxYO31TXsQK5EOFmx/Wwcw1/SqRluNchY81mT5AzWq5N9kL86FneVFwxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mw4S6MY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mw4S6MY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CC8C433F1;
	Thu, 22 Feb 2024 23:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645222;
	bh=6XTdRoqyBbv+NMgyMamw1aMI63j25nzju8K5e+2Qzuc=;
	h=Date:To:From:Subject:From;
	b=Mw4S6MY0gL07Dga/1Q6QdkjD7ezA45MuAXbWKRKKnbdJTJdNXQfV5kgMuKuDElt1S
	 tnHPp24AomuADm/ZoV/KpCSEPaxT/kmXvd30zCDS3mKg2/ZASII+U9BkYMkah+R/ZQ
	 pXhbgfnzxCWL1piREu8q/pH2UzzrnV6Xr17PGu0M=
Date: Thu, 22 Feb 2024 15:40:21 -0800
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] list-leverage-list_is_head-for-list_entry_is_head.patch removed from -mm tree
Message-Id: <20240222234022.70CC8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: list: leverage list_is_head() for list_entry_is_head()
has been removed from the -mm tree.  Its filename was
     list-leverage-list_is_head-for-list_entry_is_head.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: list: leverage list_is_head() for list_entry_is_head()
Date: Thu, 8 Feb 2024 02:14:23 +0000

This is what list_is_head() exactly do.

Link: https://lkml.kernel.org/r/20240208021423.15704-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/list.h~list-leverage-list_is_head-for-list_entry_is_head
+++ a/include/linux/list.h
@@ -766,7 +766,7 @@ static inline size_t list_count_nodes(st
  * @member:	the name of the list_head within the struct.
  */
 #define list_entry_is_head(pos, head, member)				\
-	(&pos->member == (head))
+	list_is_head(&pos->member, (head))
 
 /**
  * list_for_each_entry	-	iterate over list of given type
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


