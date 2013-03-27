From: akpm@linux-foundation.org
Subject: + idr-introduce-idr_alloc_cyclic.patch added to -mm tree
Date: Wed, 27 Mar 2013 13:22:10 -0700
Message-ID: <20130327202211.12D4E31C2AD@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:64728 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395Ab3C0UWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 16:22:13 -0400
Received: by mail-ve0-f202.google.com with SMTP id m1so326682ves.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 13:22:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@fieldses.org, davem@davemloft.net, eparis@parisplace.org, jackm@dev.mellanox.co.il, john@johnmccutchan.com, nhorman@tuxdriver.com, ogerlitz@mellanox.com, rlove@rlove.org, roland@purestorage.com, sri@us.ibm.com, swise@opengridcomputing.com, tj@kernel.org, tom@opengridcomputing.com, vyasevich@gmail.com


The patch titled
     Subject: idr: introduce idr_alloc_cyclic()
has been added to the -mm tree.  Its filename is
     idr-introduce-idr_alloc_cyclic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: idr: introduce idr_alloc_cyclic()

As Tejun points out, there are several users of the IDR facility that
attempt to use it in a cyclic fashion.  These users are likely to see
-ENOSPC errors after the counter wraps one or more times however.

This patchset adds a new idr_alloc_cyclic routine and converts several of
these users to it.  Many of these users are in obscure parts of the
kernel, and I don't have a good way to test some of them.  The change is
pretty straightforward though, so hopefully it won't be an issue.

There is one other cyclic user of idr_alloc that I didn't touch in
ipc/util.c.  That one is doing some strange stuff that I didn't quite
understand, but it looks like it should probably be converted later
somehow.


This patch:

Thus spake Tejun Heo:

    Ooh, BTW, the cyclic allocation is broken.  It's prone to -ENOSPC
    after the first wraparound.  There are several cyclic users in the
    kernel and I think it probably would be best to implement cyclic
    support in idr.

This patch does that by adding new idr_alloc_cyclic function that such
users in the kernel can use.  With this, there's no need for a caller to
keep track of the last value used as that's now tracked internally.  This
should prevent the ENOSPC problems that can hit when the "last allocated"
counter exceeds INT_MAX.

Later patches will convert existing cyclic users to the new interface.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Sridhar Samudrala <sri@us.ibm.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |    2 ++
 lib/idr.c           |   27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff -puN include/linux/idr.h~idr-introduce-idr_alloc_cyclic include/linux/idr.h
--- a/include/linux/idr.h~idr-introduce-idr_alloc_cyclic
+++ a/include/linux/idr.h
@@ -42,6 +42,7 @@ struct idr {
 	struct idr_layer	*id_free;
 	int			layers;	/* only valid w/o concurrent changes */
 	int			id_free_cnt;
+	int			cur;	/* current pos for cyclic allocation */
 	spinlock_t		lock;
 };
 
@@ -75,6 +76,7 @@ struct idr {
 void *idr_find_slowpath(struct idr *idp, int id);
 void idr_preload(gfp_t gfp_mask);
 int idr_alloc(struct idr *idp, void *ptr, int start, int end, gfp_t gfp_mask);
+int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask);
 int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data);
 void *idr_get_next(struct idr *idp, int *nextid);
diff -puN lib/idr.c~idr-introduce-idr_alloc_cyclic lib/idr.c
--- a/lib/idr.c~idr-introduce-idr_alloc_cyclic
+++ a/lib/idr.c
@@ -495,6 +495,33 @@ int idr_alloc(struct idr *idr, void *ptr
 }
 EXPORT_SYMBOL_GPL(idr_alloc);
 
+/**
+ * idr_alloc_cyclic - allocate new idr entry in a cyclical fashion
+ * @idr: the (initialized) idr
+ * @ptr: pointer to be associated with the new id
+ * @start: the minimum id (inclusive)
+ * @end: the maximum id (exclusive, <= 0 for max)
+ * @gfp_mask: memory allocation flags
+ *
+ * Essentially the same as idr_alloc, but prefers to allocate progressively
+ * higher ids if it can. If the "cur" counter wraps, then it will start again
+ * at the "start" end of the range and allocate one that has already been used.
+ */
+int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end,
+			gfp_t gfp_mask)
+{
+	int id;
+
+	id = idr_alloc(idr, ptr, max(start, idr->cur), end, gfp_mask);
+	if (id == -ENOSPC)
+		id = idr_alloc(idr, ptr, start, end, gfp_mask);
+
+	if (likely(id >= 0))
+		idr->cur = id + 1;
+	return id;
+}
+EXPORT_SYMBOL(idr_alloc_cyclic);
+
 static void idr_remove_warning(int id)
 {
 	printk(KERN_WARNING
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch
idr-introduce-idr_alloc_cyclic.patch
drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch
drivers-infiniband-hw-mlx4-convert-to-using-idr_alloc_cyclic.patch
nfsd-convert-nfs4_alloc_stid-to-use-idr_alloc_cyclic.patch
inotify-convert-inotify_add_to_idr-to-use-idr_alloc_cyclic.patch
sctp-convert-sctp_assoc_set_id-to-use-idr_alloc_cyclic.patch

