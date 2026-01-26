Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B250C23E340
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 18:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769451978; cv=none; b=XFy0+Vgf7EekGmbDk6IZxw9p/ApjmGKcdLOkzd/pbFtRVpe0CktjEQmi2nG/XqYbLSrLEydZbyviTjIArNoyNLOKH1RkaACVTx1Ig6Nfu3lcOM+OdA/CXr3cAnC3yq8BpbXi2/RCJUp6qLnMqhGJMsgKGIwMlMLrlY+u4/+GHxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769451978; c=relaxed/simple;
	bh=SPRgHEB++XisltI/Ib5h9BS4IT7y8bOC1n23MtR1cew=;
	h=Date:To:From:Subject:Message-Id; b=PvMq5B5oDqcsntx8TeuFkj+5iANhrkf6E3XtpMYqDIxm10T5gNd7POV2guQwakNuYTRelUnBoouGrpy4u4O9Hj9I1sFRXTLI4LuVordosll19kOXJPldO3Ysvfm05QqSOgEqyjXAct1lTXrSjUYbfh1A9ZLqRtfMX6CGeyx1tDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EvGnROXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EvGnROXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7567C116C6;
	Mon, 26 Jan 2026 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769451978;
	bh=SPRgHEB++XisltI/Ib5h9BS4IT7y8bOC1n23MtR1cew=;
	h=Date:To:From:Subject:From;
	b=EvGnROXbzTXgl0bGfX/0KnS4+x13pi8F2h/noLSeLuqceAEZ/E+SySsJxGfo74Vej
	 KGvVVCqhcHm4FJvnhiooGapS3c+G/Gi+/WqDIpotPC1DTzkCfUEWhqTKhnTi1PXe1g
	 1zkAO0+EJHXCXs75cNXetgNQBd5/IdpggLg38lxU=
Date: Mon, 26 Jan 2026 10:26:17 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-cma-replace-snprintf-with-strscpy-in-cma_new_area.patch added to mm-new branch
Message-Id: <20260126182617.E7567C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/cma: replace snprintf with strscpy in cma_new_area
has been added to the -mm mm-new branch.  Its filename is
     mm-cma-replace-snprintf-with-strscpy-in-cma_new_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-cma-replace-snprintf-with-strscpy-in-cma_new_area.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/cma: replace snprintf with strscpy in cma_new_area
Date: Mon, 26 Jan 2026 18:45:15 +0100

Replace snprintf("%s", ...) with the faster and more direct strscpy().

Link: https://lkml.kernel.org/r/20260126174516.236968-1-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-replace-snprintf-with-strscpy-in-cma_new_area
+++ a/mm/cma.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/string_choices.h>
 #include <linux/log2.h>
 #include <linux/cma.h>
@@ -233,7 +234,7 @@ static int __init cma_new_area(const cha
 	cma_area_count++;
 
 	if (name)
-		snprintf(cma->name, CMA_MAX_NAME, "%s", name);
+		strscpy(cma->name, name);
 	else
 		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
 
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-cma-replace-snprintf-with-strscpy-in-cma_new_area.patch

