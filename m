Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560627;
	b=KhtwnpTZSARDwwmlC9NUfu31Ax5PBLndk5O7ZEseIrEmlqMhevaKz7ELO+MVyNA+xKXe
	 CUa2sUOhCGo8dPmrPagz3JCUi0EJAFlHgHJo9C7u08S2Tl7oS7+kV05JQudGV5IjzU7gW
	 eVBJJORQhnkk88RvKHFOKlNo7pVHD1McIdixfzDev+XP1y6K0HtTOeUMnVYKK04KMzZCk
	 y+7F8Vmudp/ONcUwqQ0Qy0JG0cHhJJaYdUUHkdkK+llG/O9QffYGK1fDoEKi7kVY3/You
	 4hGo38Yk0aczOoyQ27hSXfFvhjxkqHwTAp1u5qYUXpSe5AmoyzBTxgIjh1KTsePVK6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560627;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=B23o8Dmx6Vk4u3O1Wb+yNg+dChzWIBe01HWO2mCcEt4=;
	b=Aw63PeyYTEXHV/soIR4XlOO27N2B1852Ep1ZLAirDqtQtMQn2h9ob1gytr2i38wVNSLR
	 LAhhx7AczTGFjw1SNun+dipEjKAFrLueVaQD7eMxND3sGIEx5SyV21r6oZBNenj2RIb2N
	 l1gtCweHRM192Zr0HpCXJglZVW9m7hhrAjm2O1oBbRt7Ym6WAACDcZUAzhdSQn+vrc6V7
	 gwuJFf38K/49+E/JEn4PH3nNMkRUnV+XfIq558FR9NvgeEpuK/78/2TUSnvfNikFyt/QD
	 h8uoTBIPW9G7y9wHUCONYNxXHj7niIdrFWb8Nil6O6/ElgGIsykPnS8oVq+chA2tlHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gxBnZHAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA2D606A324;
	Wed, 21 Oct 2026 05:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gxBnZHAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049A41F000C9;
	Wed, 21 Oct 2026 05:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792560627;
	bh=B23o8Dmx6Vk4u3O1Wb+yNg+dChzWIBe01HWO2mCcEt4=;
	h=Date:To:From:Subject;
	b=gxBnZHAbbqt2ltkEf562Fq7MQRmlEnl3WGOXr677kqMLmY1nkdw/aqgKCPQ73RwwJ
	 fkDSVWUs06zjIpo2IC1jzjFmFF95D6xUEjqnL1zq/b3QPSSy8g5HTam8POgNdSdNvp
	 tf9YphW9NwNk521IcsO6qvV/gfILhTLgHF2OiZLM=
Date: Tue, 20 Oct 2026 22:30:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mark@fasheh.com,jlbec@evilplan.org,heming.zhao@suse.com,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch removed from -mm tree
Message-Id: <20261021053027.049A41F000C9@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: ocfs2: reserve value tree metadata when moving an xattr into the inode
has been removed from the -mm tree.  Its filename was
     ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: reserve value tree metadata when moving an xattr into the inode
Date: Sat, 10 Oct 2026 19:34:53 +0800

ocfs2_calc_xattr_set_need() charges no metadata for the case where an
xattr living in an xattr block or bucket moves back into the inode:

        if (old_in_xb) {
                if (ocfs2_xattr_can_be_in_inode(inode, xi, xis)) {
                        clusters_add += new_clusters;
                        credits += ...;
                        if (!ocfs2_xattr_is_local(xe))
                                credits += ocfs2_calc_extend_credits(...);
                        goto out;
                }
        }

The credits for extending a value tree are there but the matching blocks
are not, so meta_add stays 0, ocfs2_init_xattr_set_ctxt() skips
ocfs2_reserve_new_metadata_blocks() and ctxt->meta_ac is left NULL.

This is the shape commit 0cdc7dde00ec ("ocfs2: fix missing metadata
reservation for large xattrs") fixed for the xattr block case, and it is
reached the same way: namevalue_size() charges a value larger than
OCFS2_XATTR_INLINE_SIZE as only OCFS2_XATTR_ROOT_SIZE, so
ocfs2_xattr_can_be_in_inode() accepts a new value that will be stored
outside.  ocfs2_xa_prepare_entry() installs a value root from def_xv and
grows it, and once the cluster allocator is fragmented enough to need a
second extent ocfs2_add_clusters_in_btree() finds the root full with no
meta_ac at all and answers RESTART_META.  ocfs2_xattr_extend_allocation()
turns that into -ENOSPC, or into a BUG_ON() without that commit, and
ocfs2_xa_cleanup_value_truncate() takes its !orig_clusters arm, dropping
the entry and leaking the clusters already handed out until fsck.ocfs2
reclaims them.

Reserve for the value tree here too.  The entry moves back into the inode
rather than into a new xattr block, so unlike the create side of
meta_guess this needs no block of its own.

Link: https://lore.kernel.org/20261010113454.1420939-3-joseph.qi@linux.alibaba.com
Fixes: 78f30c314a74 ("ocfs2/xattr: Reserve meta/data at the beginning of ocfs2_xattr_set.")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
---

 fs/ocfs2/xattr.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ocfs2/xattr.c~ocfs2-reserve-value-tree-metadata-when-moving-an-xattr-into-the-inode
+++ a/fs/ocfs2/xattr.c
@@ -3480,6 +3480,14 @@ static int ocfs2_calc_xattr_set_need(str
 				credits += ocfs2_calc_extend_credits(
 							inode->i_sb,
 							&def_xv.xv.xr_list);
+			/*
+			 * A value too big to stay inline is only charged as
+			 * OCFS2_XATTR_ROOT_SIZE above, so it can still need a
+			 * value tree of its own.  No xattr block is allocated
+			 * on this path, so the tree is all we reserve for.
+			 */
+			if (xi->xi_value_len > OCFS2_XATTR_INLINE_SIZE)
+				meta_add += ocfs2_extend_meta_needed(&def_xv.xv.xr_list);
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


