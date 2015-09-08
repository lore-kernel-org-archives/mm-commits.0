From: akpm@linux-foundation.org
Subject: [merged] userfaultfd-uffdio_copy-and-uffdio_zeropage.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:04:53 -0700
Message-ID: <55ef2345.VVDjx8BGaW3LmUPg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbbIHSEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, andreslc@google.com, dave.hansen@intel.com, dgilbert@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, luto@amacapital.net, mgorman@suse.de, pbonzini@redhat.com, peter.huangpeng@huawei.com, pfeiner@google.com, riel@redhat.com, sanidhya.gatech@gmail.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: UFFDIO_COPY and UFFDIO_ZEROPAGE
has been removed from the -mm tree.  Its filename was
     userfaultfd-uffdio_copy-and-uffdio_zeropage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: UFFDIO_COPY and UFFDIO_ZEROPAGE

These two ioctl allows to either atomically copy or to map zeropages
into the virtual address space. This is used by the thread that opened
the userfaultfd to resolve the userfaults.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Cc: zhang.zhanghailiang@huawei.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   96 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff -puN fs/userfaultfd.c~userfaultfd-uffdio_copy-and-uffdio_zeropage fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-uffdio_copy-and-uffdio_zeropage
+++ a/fs/userfaultfd.c
@@ -983,6 +983,96 @@ out:
 	return ret;
 }
 
+static int userfaultfd_copy(struct userfaultfd_ctx *ctx,
+			    unsigned long arg)
+{
+	__s64 ret;
+	struct uffdio_copy uffdio_copy;
+	struct uffdio_copy __user *user_uffdio_copy;
+	struct userfaultfd_wake_range range;
+
+	user_uffdio_copy = (struct uffdio_copy __user *) arg;
+
+	ret = -EFAULT;
+	if (copy_from_user(&uffdio_copy, user_uffdio_copy,
+			   /* don't copy "copy" last field */
+			   sizeof(uffdio_copy)-sizeof(__s64)))
+		goto out;
+
+	ret = validate_range(ctx->mm, uffdio_copy.dst, uffdio_copy.len);
+	if (ret)
+		goto out;
+	/*
+	 * double check for wraparound just in case. copy_from_user()
+	 * will later check uffdio_copy.src + uffdio_copy.len to fit
+	 * in the userland range.
+	 */
+	ret = -EINVAL;
+	if (uffdio_copy.src + uffdio_copy.len <= uffdio_copy.src)
+		goto out;
+	if (uffdio_copy.mode & ~UFFDIO_COPY_MODE_DONTWAKE)
+		goto out;
+
+	ret = mcopy_atomic(ctx->mm, uffdio_copy.dst, uffdio_copy.src,
+			   uffdio_copy.len);
+	if (unlikely(put_user(ret, &user_uffdio_copy->copy)))
+		return -EFAULT;
+	if (ret < 0)
+		goto out;
+	BUG_ON(!ret);
+	/* len == 0 would wake all */
+	range.len = ret;
+	if (!(uffdio_copy.mode & UFFDIO_COPY_MODE_DONTWAKE)) {
+		range.start = uffdio_copy.dst;
+		wake_userfault(ctx, &range);
+	}
+	ret = range.len == uffdio_copy.len ? 0 : -EAGAIN;
+out:
+	return ret;
+}
+
+static int userfaultfd_zeropage(struct userfaultfd_ctx *ctx,
+				unsigned long arg)
+{
+	__s64 ret;
+	struct uffdio_zeropage uffdio_zeropage;
+	struct uffdio_zeropage __user *user_uffdio_zeropage;
+	struct userfaultfd_wake_range range;
+
+	user_uffdio_zeropage = (struct uffdio_zeropage __user *) arg;
+
+	ret = -EFAULT;
+	if (copy_from_user(&uffdio_zeropage, user_uffdio_zeropage,
+			   /* don't copy "zeropage" last field */
+			   sizeof(uffdio_zeropage)-sizeof(__s64)))
+		goto out;
+
+	ret = validate_range(ctx->mm, uffdio_zeropage.range.start,
+			     uffdio_zeropage.range.len);
+	if (ret)
+		goto out;
+	ret = -EINVAL;
+	if (uffdio_zeropage.mode & ~UFFDIO_ZEROPAGE_MODE_DONTWAKE)
+		goto out;
+
+	ret = mfill_zeropage(ctx->mm, uffdio_zeropage.range.start,
+			     uffdio_zeropage.range.len);
+	if (unlikely(put_user(ret, &user_uffdio_zeropage->zeropage)))
+		return -EFAULT;
+	if (ret < 0)
+		goto out;
+	/* len == 0 would wake all */
+	BUG_ON(!ret);
+	range.len = ret;
+	if (!(uffdio_zeropage.mode & UFFDIO_ZEROPAGE_MODE_DONTWAKE)) {
+		range.start = uffdio_zeropage.range.start;
+		wake_userfault(ctx, &range);
+	}
+	ret = range.len == uffdio_zeropage.range.len ? 0 : -EAGAIN;
+out:
+	return ret;
+}
+
 /*
  * userland asks for a certain API version and we return which bits
  * and ioctl commands are implemented in this kernel for such API
@@ -1038,6 +1128,12 @@ static long userfaultfd_ioctl(struct fil
 	case UFFDIO_WAKE:
 		ret = userfaultfd_wake(ctx, arg);
 		break;
+	case UFFDIO_COPY:
+		ret = userfaultfd_copy(ctx, arg);
+		break;
+	case UFFDIO_ZEROPAGE:
+		ret = userfaultfd_zeropage(ctx, arg);
+		break;
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

