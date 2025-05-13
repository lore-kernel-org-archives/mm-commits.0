Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8EF1EB5E6
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119214; cv=none; b=G7GLcH7JANqQRUDOV1lB8fcLUtEjmtb8kcNDwXI0n5M6z6X25edFa9PnGuJ6FU+uwPrgMhNeeiGtrcg3YkDW3hgsghJyJQYAVi+PPst6E+mP13str0qir11olvlQM+7DQV/BKyy+L7u9zz7xNv3cyUP4SsiWyjwG4iw5nXjNbqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119214; c=relaxed/simple;
	bh=vD6XsIPO0Ga8p1v3BiLuS2c9cGf1H3paMqZl5DI2gBs=;
	h=Date:To:From:Subject:Message-Id; b=PLYzp/UiApSUkh9zB5vneRB67xsHOyYz6A2clRSGicQfTEH/I4UmT3puNRsx7KeQHYhGoUljonGisbIDy5Qr9yiP8ohcmsUuthNhh0/rmMZccAR/I3VQVgoBkG/8MaUpxLTdUcfcMnEA1TTAik32wPIy4leI/wpcrMjjk6kSqS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tuH1/FE3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tuH1/FE3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51174C4CEE4;
	Tue, 13 May 2025 06:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119214;
	bh=vD6XsIPO0Ga8p1v3BiLuS2c9cGf1H3paMqZl5DI2gBs=;
	h=Date:To:From:Subject:From;
	b=tuH1/FE3ukEA+Q1I5dODWiHsUr4hxzNlRUS9JxBTVqy+hmyqE4x5WMrC4dMaDizq6
	 6n6bu0hylG3wEgoHIFun5Y8u0rYDLHfClaZEbezE+ZAXZX9V4r0XJOE2m5Wfvw43RR
	 ehv723Fo7fPylDVw0iihz/csvTzEUvdt0zcKhkXk=
Date: Mon, 12 May 2025 23:53:33 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,urezki@gmail.com,shivankg@amd.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch removed from -mm tree
Message-Id: <20250513065334.51174C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc.c: find the vmap of vmap_nodes in reverse order
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc.c: find the vmap of vmap_nodes in reverse order
Date: Sat, 19 Apr 2025 06:36:50 +0800

When finding VA in vn->busy, if VA spans several zones and the passed addr
is not the same as va->va_start, we should scan the vn in reverse odrdr
because the starting address of VA must be smaller than the passed addr if
it really resides in the VA.

E.g on a system nr_vmap_nodes=100,

     <----va---->
 -|-----|-----|-----|-----|-----|-----|-----|-----|-----|-
    ...   n-1   n    n+1   n+2   ...   100     0     1

VA resides in node 'n' whereas it spans 'n', 'n+1' and 'n+2'.  If passed
addr is within 'n+2', we should try nodes backwards on 'n+1' and 'n', then
succeed very soon.

Meanwhile we still need loop around because VA could spans node from 'n'
to node 100, node 0, node 1.

Anyway, changing to find in reverse order can improve efficiency on many
CPUs system.

Link: https://lkml.kernel.org/r/20250418223653.243436-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-find-the-vmap-of-vmap_nodes-in-reverse-order
+++ a/mm/vmalloc.c
@@ -2435,7 +2435,7 @@ struct vmap_area *find_vmap_area(unsigne
 
 		if (va)
 			return va;
-	} while ((i = (i + 1) % nr_vmap_nodes) != j);
+	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
 
 	return NULL;
 }
@@ -2461,7 +2461,7 @@ static struct vmap_area *find_unlink_vma
 
 		if (va)
 			return va;
-	} while ((i = (i + 1) % nr_vmap_nodes) != j);
+	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
 
 	return NULL;
 }
_

Patches currently in -mm which might be from bhe@redhat.com are


