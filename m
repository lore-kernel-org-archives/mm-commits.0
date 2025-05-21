Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD4E32C85;
	Wed, 21 May 2025 05:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747806605; cv=none; b=m1jcEHviCMlg2j5qaDq5bcZDNgriaiKu+rpGjKidY2lJ5KcsEXvfovGKZp3PV3xDPxZaOSIJT1GlJgHPKlYefJ9kjrBqSl2bHLYfqAS5cPm7/3bFhhPlN+qHCvb9DVYv2NxKNI16AmKY9TkgWkxcOgUNB4HkxIambNf5Tegn1cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747806605; c=relaxed/simple;
	bh=puFcKJv511n0orNbEA64IeC4w7VQsIxrtBCSB6wSO/Y=;
	h=Date:To:From:Subject:Message-Id; b=okGOckZbT+3bBykKfRGyQJBm+GDVzgnNo/yFCl6+FXHRtWa9xCTG5cNwuoiaMoHkyMX2or1155yPUAjr/BRuxAgWLf0oZvnJ+wao/vTuTt/6jUmggWf0y9YcpVPW5sXYkdym4nxFJEcQKZxRiUH06iGORGs3+C1TatmD1mdUTbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xwIXkdOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xwIXkdOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00618C4CEE4;
	Wed, 21 May 2025 05:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747806605;
	bh=puFcKJv511n0orNbEA64IeC4w7VQsIxrtBCSB6wSO/Y=;
	h=Date:To:From:Subject:From;
	b=xwIXkdOA2PrK8A7f8EjHfglRVYU6Lk74AmJ6/CbwLI5HEIHg4fvdauSvEMRYwPYIA
	 D9y4l0sItb9YIAiHyuMTXFySlFHOf4sW8JhlCxWunK9HJgTVQsvQQ5BIWGnMzdpXBL
	 SeDAHMremj/uiL8LyxEkDPJ40SIN/0o98LKg/I/c=
Date: Tue, 20 May 2025 22:50:04 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,david@redhat.com,Ignacio.MorenoGonzalez@kuka.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled.patch removed from -mm tree
Message-Id: <20250521055005.00618C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP is enabled
has been removed from the -mm tree.  Its filename was
     mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Subject: mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP is enabled
Date: Wed, 07 May 2025 15:28:06 +0200

commit c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE") maps the
mmap option MAP_STACK to VM_NOHUGEPAGE.  This is also done if
CONFIG_TRANSPARENT_HUGEPAGE is not defined.  But in that case, the
VM_NOHUGEPAGE does not make sense.

I discovered this issue when trying to use the tool CRIU to checkpoint and
restore a container.  Our running kernel is compiled without
CONFIG_TRANSPARENT_HUGEPAGE.  CRIU parses the output of /proc/<pid>/smaps
and saves the "nh" flag.  When trying to restore the container, CRIU fails
to restore the "nh" mappings, since madvise() MADV_NOHUGEPAGE always
returns an error because CONFIG_TRANSPARENT_HUGEPAGE is not defined.

Link: https://lkml.kernel.org/r/20250507-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled-v5-1-c6c38cfefd6e@kuka.com
Fixes: c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE")
Signed-off-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mman.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/mman.h~mm-mmap-map-map_stack-to-vm_nohugepage-only-if-thp-is-enabled
+++ a/include/linux/mman.h
@@ -155,7 +155,9 @@ calc_vm_flag_bits(struct file *file, uns
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	       _calc_vm_trans(flags, MAP_STACK,	     VM_NOHUGEPAGE) |
+#endif
 	       arch_calc_vm_flag_bits(file, flags);
 }
 
_

Patches currently in -mm which might be from Ignacio.MorenoGonzalez@kuka.com are


