Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8008A182D2;
	Sun, 26 Oct 2025 03:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761451162; cv=none; b=NSh8gx4R2dcgQ/5YrbIi7PSDcDxC4kFerHBNl4W29IOrMJzX016k5kINZ5CSpWmG3/Niq2p6zp7NJ1H2aD5OIic0bpFo9FVwwZ1+9J+A+WN6MSRKl84zRoI2Ca/NVyxO8JugCRLURD7hCu2RdMgUPvLK8jn1DOytaGGZ0pWYDf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761451162; c=relaxed/simple;
	bh=6Gp9raUBPHcZ4I/DV/S1GtUuBi+6/amBX7YEBV0n6cQ=;
	h=Date:To:From:Subject:Message-Id; b=IJDxGPm3DEK807W1e82IWcycHpPZ+aO12ACOf283hBjUDbbbOnxsn5QhKllVbPB6gGPOSrjGJHhcboPOrH0UdwBjVt7uAwyj5Ddl9yGqaf+Yczq8LvspCjlSgomzs8Dw7DpqJmUMosjCOeHn0qtrGCdkx1vv29j/Kdl1EaJa0RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ly4Cm5bJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ly4Cm5bJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD8EC4CEE7;
	Sun, 26 Oct 2025 03:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761451162;
	bh=6Gp9raUBPHcZ4I/DV/S1GtUuBi+6/amBX7YEBV0n6cQ=;
	h=Date:To:From:Subject:From;
	b=Ly4Cm5bJjfDLi1A2H3o245ndxniftc7qQE+5XAkTzrjWGexf3nCyAJD61W91UPTNp
	 rxKP+jwPj+MDRD4Ssv/EPYbsZO7VIhpaYs+8ccqfCyn0Kgfa5hzVRgfIY5ewaTCYlS
	 7fPCYLMyMhLvQO29fovrosSMCJ8AqBXmuEcDmCG4=
Date: Sat, 25 Oct 2025 20:59:21 -0700
To: mm-commits@vger.kernel.org,wangzijie1@honor.com,viro@zeniv.linux.org.uk,stable@vger.kernel.org,brauner@kernel.org,adobriyan@gmail.com,albinwyang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-fix-uaf-in-proc_readdir_de.patch added to mm-hotfixes-unstable branch
Message-Id: <20251026035921.DDD8EC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: fix uaf in proc_readdir_de()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-fix-uaf-in-proc_readdir_de.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-fix-uaf-in-proc_readdir_de.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Wei Yang <albinwyang@tencent.com>
Subject: fs/proc: fix uaf in proc_readdir_de()
Date: Sat, 25 Oct 2025 10:42:33 +0800

Pde is erased from subdir rbtree through rb_erase(), but not set the node
to EMPTY, which may result in uaf access.  We should use RB_CLEAR_NODE()
set the erased node to EMPTY, then pde_subdir_next() will return NULL to
avoid uaf access.

We found an uaf issue while using stress-ng testing, need to run testcase
getdent and tun in the same time.  The steps of the issue is as follows:

1) use getdent to traverse dir /proc/pid/net/dev_snmp6/, and current
   pde is tun3;

2) in the [time windows] unregister netdevice tun3 and tun2, and erase
   them from rbtree.  erase tun3 first, and then erase tun2.  the
   pde(tun2) will be released to slab;

3) continue to getdent process, then pde_subdir_next() will return
   pde(tun2) which is released, it will case uaf access.

CPU 0                                      |    CPU 1
----------------------------------------------------------------------------------------------
traverse dir /proc/pid/net/dev_snmp6/      |   unregister_netdevice(tun->dev)   //tun3 tun2
sys_getdents64()                           |
  iterate_dir()                            |
    proc_readdir()                         |
      proc_readdir_de()                    |     snmp6_unregister_dev()
        pde_get(de);                       |       proc_remove()
        read_unlock(&proc_subdir_lock);    |         remove_proc_subtree()
                                           |           write_lock(&proc_subdir_lock);
        [time window]                      |           rb_erase(&root->subdir_node, &parent->subdir);
                                           |           write_unlock(&proc_subdir_lock);
        read_lock(&proc_subdir_lock);      |
        next = pde_subdir_next(de);        |
        pde_put(de);                       |
        de = next;    //UAF                |

rbtree of dev_snmp6
                        |
                    pde(tun3)
                     /    \
                  NULL  pde(tun2)

Link: https://lkml.kernel.org/r/20251025024233.158363-1-albin_yang@163.com
Signed-off-by: Wei Yang <albinwyang@tencent.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: wangzijie <wangzijie1@honor.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/proc/generic.c~fs-proc-fix-uaf-in-proc_readdir_de
+++ a/fs/proc/generic.c
@@ -698,6 +698,12 @@ void pde_put(struct proc_dir_entry *pde)
 	}
 }
 
+static void pde_erase(struct proc_dir_entry *pde, struct proc_dir_entry *parent)
+{
+	rb_erase(&pde->subdir_node, &parent->subdir);
+	RB_CLEAR_NODE(&pde->subdir_node);
+}
+
 /*
  * Remove a /proc entry and free it if it's not currently in use.
  */
@@ -720,7 +726,7 @@ void remove_proc_entry(const char *name,
 			WARN(1, "removing permanent /proc entry '%s'", de->name);
 			de = NULL;
 		} else {
-			rb_erase(&de->subdir_node, &parent->subdir);
+			pde_erase(de, parent);
 			if (S_ISDIR(de->mode))
 				parent->nlink--;
 		}
@@ -764,7 +770,7 @@ int remove_proc_subtree(const char *name
 			root->parent->name, root->name);
 		return -EINVAL;
 	}
-	rb_erase(&root->subdir_node, &parent->subdir);
+	pde_erase(root, parent);
 
 	de = root;
 	while (1) {
@@ -776,7 +782,7 @@ int remove_proc_subtree(const char *name
 					next->parent->name, next->name);
 				return -EINVAL;
 			}
-			rb_erase(&next->subdir_node, &de->subdir);
+			pde_erase(next, de);
 			de = next;
 			continue;
 		}
_

Patches currently in -mm which might be from albinwyang@tencent.com are

fs-proc-fix-uaf-in-proc_readdir_de.patch

