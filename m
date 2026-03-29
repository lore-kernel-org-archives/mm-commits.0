Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075F010F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744839; cv=none; b=MgX3f/MFXbJVYBauAYKWVaVXpcWyK/A9sXyzy12rAXsLOIpoH3BrcdVo1P1xnH45GXP/wQ2pECmP9S44DJD/QTu9TA/I3xMD3YiH3T5goQqDzQj09OQSwzZ3CCI8IndUOYEYTHJIorptYhEl81Fb+/jC0blJCAgdtAwNO5/hMug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744839; c=relaxed/simple;
	bh=1BMDXPrn9rHypTgXerrAeAA1zgqXajgptKLIPdAio2A=;
	h=Date:To:From:Subject:Message-Id; b=IOgZzsOKSgPL9wCRmjdWHEPaQFMSE/xqBOKb/9tymEdd2InvlCVHh/nOMP3f+jOGMTiP+lBH749OrEM+JHHlSjgXjS0YrOccLApfDMxMLWjy9DgS4J9u9wn3x7OAIjiMhtSewyWT6W9YP8pkdrZn88EEIVQE1IcMQwS2pd70yNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p5w0tmOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p5w0tmOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D394AC4CEF7;
	Sun, 29 Mar 2026 00:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744838;
	bh=1BMDXPrn9rHypTgXerrAeAA1zgqXajgptKLIPdAio2A=;
	h=Date:To:From:Subject:From;
	b=p5w0tmOSmN/6OU+azULZ76RB5uPxCvPgLEkfJb5zRPQuzQlLWly065fd5CG+Y6NbJ
	 /AyszeuBx0OiELSIO13LEEgiIR05RPm6m8UJvo4POAUAuwqc0QA4I+jj/cciWZjelZ
	 BEkYoKyJw5Iejf+TYiwaKUImVoebQWc3OoCRwhM8=
Date: Sat, 28 Mar 2026 17:40:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-document-non-zero-length-damon_region-assumption.patch removed from -mm tree
Message-Id: <20260329004038.D394AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: document non-zero length damon_region assumption
has been removed from the -mm tree.  Its filename was
     mm-damon-document-non-zero-length-damon_region-assumption.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: document non-zero length damon_region assumption
Date: Sat, 7 Mar 2026 11:53:52 -0800

DAMON regions are assumed to always be non-zero length.  There was a
confusion [1] about it, probably due to lack of the documentation. 
Document it.

Link: https://lkml.kernel.org/r/20260307195356.203753-5-sj@kernel.org
Link: https://lore.kernel.org/20251231070029.79682-1-sj@kernel.org/ [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/damon.h~mm-damon-document-non-zero-length-damon_region-assumption
+++ a/include/linux/damon.h
@@ -55,6 +55,8 @@ struct damon_size_range {
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
+ * For any use case, @ar should be non-zero positive size.
+ *
  * @nr_accesses is reset to zero for every &damon_attrs->aggr_interval and be
  * increased for every &damon_attrs->sample_interval if an access to the region
  * during the last sampling interval is found.  The update of this field should
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch

