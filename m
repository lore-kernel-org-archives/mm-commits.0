Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD912146588
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729736781; cv=none; b=lbCbLqi22vAYCjo/udDFYdrgaTyEHPNo7Ptxnux/1yjG00vXaoc2j85uP/OMKrT3YILA069N5xSVIn2R3L18JH1cCbTkoIQ4s5JAJqe0nlWl1tG5Bz7SChs98gRSQZ0h5SkFhHd33tYF/mnhNjBaEKZPhZgMf90EQgd08vPW860=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729736781; c=relaxed/simple;
	bh=GtA8L0k4eZ6M9QZo71fCKVmlI4dCoUPiV7i4uXiTb+4=;
	h=Date:To:From:Subject:Message-Id; b=ue3OR1XxMzc0URqSwDElLsbRLk1m4wncBdohAaDa0hHIK6c7Ey2441KpzszmXg9hDDamyUEJP5dfnjjOcRufJJWnPQvoHsbQukNyxEji2UrEJGXpBAdfWkPgJtoULZ2Ei/iIMY0RvaD6OrbECNd+XT9TA1vDYSAaOyKUsP6xnvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TSH+fapI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TSH+fapI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2379CC4CEC6;
	Thu, 24 Oct 2024 02:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729736781;
	bh=GtA8L0k4eZ6M9QZo71fCKVmlI4dCoUPiV7i4uXiTb+4=;
	h=Date:To:From:Subject:From;
	b=TSH+fapIhMh5ifgANo0IudjJER2iGuAUHw/nXhXXTPTSXgnMw/9lfjKW0fkZONw+L
	 3dqI8Wae1l1wiVeigTqZumzHrlTkdbPy06vvTE8EHN8zILiL6M0At+J5Tv7NQVUd9D
	 t4mWLBsIPCMaj4/kld0gXlu4yLcsFfmKPQhJ+2v0=
Date: Wed, 23 Oct 2024 19:26:20 -0700
To: mm-commits@vger.kernel.org,liujing@cmss.chinamobile.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-free-the-allocated-memory.patch added to mm-nonmm-unstable branch
Message-Id: <20241024022621.2379CC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: Free the allocated memory
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-mm-free-the-allocated-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-free-the-allocated-memory.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Liu Jing <liujing@cmss.chinamobile.com>
Subject: tools/mm: Free the allocated memory
Date: Tue, 22 Oct 2024 09:25:26 +0800

The comm_str memory needs to be freed if the search_pattern function call
fails in get_comm

Link: https://lkml.kernel.org/r/20241022012526.7597-1-liujing@cmss.chinamobile.com
Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/mm/page_owner_sort.c~tools-mm-free-the-allocated-memory
+++ a/tools/mm/page_owner_sort.c
@@ -377,6 +377,7 @@ static char *get_comm(char *buf)
 	if (errno != 0) {
 		if (debug_on)
 			fprintf(stderr, "wrong comm in follow buf:\n%s\n", buf);
+		free (comm_str);
 		return NULL;
 	}
 
_

Patches currently in -mm which might be from liujing@cmss.chinamobile.com are

tools-mm-free-the-allocated-memory.patch

