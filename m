Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6452BC678DB
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjASBS7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjASBQu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:16:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3C06B9AC
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6502B81D66
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52504C433D2;
        Thu, 19 Jan 2023 01:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090911;
        bh=hxEnVH/R4jYWa962XRy/zlnwyX9ylb0K6umeqI/hm9A=;
        h=Date:To:From:Subject:From;
        b=Ou0sFrdCIzrpLQOUwKIhAIxfhNEvKWR8+aBrWk+whlCOpS/6ltJN0X9PAtk9egUjx
         ofUbor+zhAw/FuR77yhuhjGKxKVNVeaeyplZre9SGNUjOrumb1MH5U6zsye9xgzxLj
         An9Z41O8LXIp/Tly89vaaN1Ebr8Ak7zWx4Py4lCU=
Date:   Wed, 18 Jan 2023 17:15:10 -0800
To:     mm-commits@vger.kernel.org, terrelln@fb.com, serge@hallyn.com,
        paul@paul-moore.com, john.johansen@canonical.com,
        jmorris@namei.org, daniel@iogearbox.net, sunhao.th@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-new-primitive-kvmemdup.patch removed from -mm tree
Message-Id: <20230119011511.52504C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: new primitive kvmemdup()
has been removed from the -mm tree.  Its filename was
     mm-new-primitive-kvmemdup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hao Sun <sunhao.th@gmail.com>
Subject: mm: new primitive kvmemdup()
Date: Wed, 21 Dec 2022 22:42:45 +0800

Similar to kmemdup(), but support large amount of bytes with kvmalloc()
and does *not* guarantee that the result will be physically contiguous. 
Use only in cases where kvmalloc() is needed and free it with kvfree(). 
Also adapt policy_unpack.c in case someone bisect into this.

Link: https://lkml.kernel.org/r/20221221144245.27164-1-sunhao.th@gmail.com
Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nick Terrell <terrelln@fb.com>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h            |    1 +
 mm/util.c                         |   24 +++++++++++++++++++++++-
 security/apparmor/policy_unpack.c |   11 +----------
 3 files changed, 25 insertions(+), 11 deletions(-)

--- a/include/linux/string.h~mm-new-primitive-kvmemdup
+++ a/include/linux/string.h
@@ -177,6 +177,7 @@ extern char *kstrdup(const char *s, gfp_
 extern const char *kstrdup_const(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp) __realloc_size(2);
+extern void *kvmemdup(const void *src, size_t len, gfp_t gfp) __realloc_size(2);
 extern char *kmemdup_nul(const char *s, size_t len, gfp_t gfp);
 
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
--- a/mm/util.c~mm-new-primitive-kvmemdup
+++ a/mm/util.c
@@ -120,7 +120,8 @@ EXPORT_SYMBOL(kstrndup);
  * @len: memory region length
  * @gfp: GFP mask to use
  *
- * Return: newly allocated copy of @src or %NULL in case of error
+ * Return: newly allocated copy of @src or %NULL in case of error,
+ * result is physically contiguous. Use kfree() to free.
  */
 void *kmemdup(const void *src, size_t len, gfp_t gfp)
 {
@@ -134,6 +135,27 @@ void *kmemdup(const void *src, size_t le
 EXPORT_SYMBOL(kmemdup);
 
 /**
+ * kvmemdup - duplicate region of memory
+ *
+ * @src: memory region to duplicate
+ * @len: memory region length
+ * @gfp: GFP mask to use
+ *
+ * Return: newly allocated copy of @src or %NULL in case of error,
+ * result may be not physically contiguous. Use kvfree() to free.
+ */
+void *kvmemdup(const void *src, size_t len, gfp_t gfp)
+{
+	void *p;
+
+	p = kvmalloc(len, gfp);
+	if (p)
+		memcpy(p, src, len);
+	return p;
+}
+EXPORT_SYMBOL(kvmemdup);
+
+/**
  * kmemdup_nul - Create a NUL-terminated string from unterminated data
  * @s: The data to stringify
  * @len: The size of the data
--- a/security/apparmor/policy_unpack.c~mm-new-primitive-kvmemdup
+++ a/security/apparmor/policy_unpack.c
@@ -161,15 +161,6 @@ VISIBLE_IF_KUNIT bool aa_inbounds(struct
 }
 EXPORT_SYMBOL_IF_KUNIT(aa_inbounds);
 
-static void *kvmemdup(const void *src, size_t len)
-{
-	void *p = kvmalloc(len, GFP_KERNEL);
-
-	if (p)
-		memcpy(p, src, len);
-	return p;
-}
-
 /**
  * aa_unpack_u16_chunk - test and do bounds checking for a u16 size based chunk
  * @e: serialized data read head (NOT NULL)
@@ -1027,7 +1018,7 @@ static struct aa_profile *unpack_profile
 
 			data->key = key;
 			data->size = aa_unpack_blob(e, &data->data, NULL);
-			data->data = kvmemdup(data->data, data->size);
+			data->data = kvmemdup(data->data, data->size, GFP_KERNEL);
 			if (data->size && !data->data) {
 				kfree_sensitive(data->key);
 				kfree_sensitive(data);
_

Patches currently in -mm which might be from sunhao.th@gmail.com are


