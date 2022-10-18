Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EF3C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJRB5h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiJRB5f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:57:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E916777E9F
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81DF0B811E0
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:57:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381C3C433C1;
        Tue, 18 Oct 2022 01:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666058251;
        bh=+8pUtIAeW1fDfuqTLssHvHn4GTQTTcAT2hfjsDZLoQw=;
        h=Date:To:From:Subject:From;
        b=AlSzugaDR6mIeKg6G5TFGbwD2TB48+IxgGyM7ZKFTCxpqQt13yO/RVLyvYKz/AArD
         HEmOpgiR5wqh4CdMkzTnoK5ngtjNVp4oCS+z0gO4RPkQQj2Et9wJI0i9tMix1W68Ae
         a4VJogNsVlj1NoLxKEGYo+KoXM1CXvJ9xQsnGooY=
Date:   Mon, 17 Oct 2022 18:57:30 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        siddhesh@gotplt.org, oliver.sang@intel.com, miklos@szeredi.hu,
        dhowells@redhat.com, cmaiolino@redhat.com, raven@themaw.net,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vfs-parse-deal-with-zero-length-string-value.patch added to mm-nonmm-unstable branch
Message-Id: <20221018015731.381C3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vfs: parse: deal with zero length string value
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     vfs-parse-deal-with-zero-length-string-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vfs-parse-deal-with-zero-length-string-value.patch

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
From: Ian Kent <raven@themaw.net>
Subject: vfs: parse: deal with zero length string value
Date: Tue, 20 Sep 2022 15:26:29 +0800

Parsing an fs string that has zero length should result in the parameter
being set to NULL so that downstream processing handles it correctly.  For
example, the proc mount table processing should print "(none)" in this
case to preserve mount record field count, but if the value points to the
NULL string this doesn't happen.

Link: https://lkml.kernel.org/r/166365878918.39016.12757946948158123324.stgit@donald.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Siddhesh Poyarekar <siddhesh@gotplt.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs_context.c            |   17 ++++++++++++-----
 fs/fs_parser.c             |   16 ++++++++++++++++
 include/linux/fs_context.h |    3 ++-
 3 files changed, 30 insertions(+), 6 deletions(-)

--- a/fs/fs_context.c~vfs-parse-deal-with-zero-length-string-value
+++ a/fs/fs_context.c
@@ -96,7 +96,9 @@ int vfs_parse_fs_param_source(struct fs_
 	if (strcmp(param->key, "source") != 0)
 		return -ENOPARAM;
 
-	if (param->type != fs_value_is_string)
+	/* source value may be NULL */
+	if (param->type != fs_value_is_string &&
+	    param->type != fs_value_is_empty)
 		return invalf(fc, "Non-string source");
 
 	if (fc->source)
@@ -175,10 +177,15 @@ int vfs_parse_fs_string(struct fs_contex
 	};
 
 	if (value) {
-		param.string = kmemdup_nul(value, v_size, GFP_KERNEL);
-		if (!param.string)
-			return -ENOMEM;
-		param.type = fs_value_is_string;
+		if (!v_size) {
+			param.string = NULL;
+			param.type = fs_value_is_empty;
+		} else {
+			param.string = kmemdup_nul(value, v_size, GFP_KERNEL);
+			if (!param.string)
+				return -ENOMEM;
+			param.type = fs_value_is_string;
+		}
 	}
 
 	ret = vfs_parse_fs_param(fc, &param);
--- a/fs/fs_parser.c~vfs-parse-deal-with-zero-length-string-value
+++ a/fs/fs_parser.c
@@ -197,6 +197,8 @@ int fs_param_is_bool(struct p_log *log,
 		     struct fs_parameter *param, struct fs_parse_result *result)
 {
 	int b;
+	if (param->type == fs_value_is_empty)
+		return 0;
 	if (param->type != fs_value_is_string)
 		return fs_param_bad_value(log, param);
 	if (!*param->string && (p->flags & fs_param_can_be_empty))
@@ -213,6 +215,8 @@ int fs_param_is_u32(struct p_log *log, c
 		    struct fs_parameter *param, struct fs_parse_result *result)
 {
 	int base = (unsigned long)p->data;
+	if (param->type == fs_value_is_empty)
+		return 0;
 	if (param->type != fs_value_is_string)
 		return fs_param_bad_value(log, param);
 	if (!*param->string && (p->flags & fs_param_can_be_empty))
@@ -226,6 +230,8 @@ EXPORT_SYMBOL(fs_param_is_u32);
 int fs_param_is_s32(struct p_log *log, const struct fs_parameter_spec *p,
 		    struct fs_parameter *param, struct fs_parse_result *result)
 {
+	if (param->type == fs_value_is_empty)
+		return 0;
 	if (param->type != fs_value_is_string)
 		return fs_param_bad_value(log, param);
 	if (!*param->string && (p->flags & fs_param_can_be_empty))
@@ -239,6 +245,8 @@ EXPORT_SYMBOL(fs_param_is_s32);
 int fs_param_is_u64(struct p_log *log, const struct fs_parameter_spec *p,
 		    struct fs_parameter *param, struct fs_parse_result *result)
 {
+	if (param->type == fs_value_is_empty)
+		return 0;
 	if (param->type != fs_value_is_string)
 		return fs_param_bad_value(log, param);
 	if (!*param->string && (p->flags & fs_param_can_be_empty))
@@ -253,6 +261,8 @@ int fs_param_is_enum(struct p_log *log,
 		     struct fs_parameter *param, struct fs_parse_result *result)
 {
 	const struct constant_table *c;
+	if (param->type == fs_value_is_empty)
+		return 0;
 	if (param->type != fs_value_is_string)
 		return fs_param_bad_value(log, param);
 	if (!*param->string && (p->flags & fs_param_can_be_empty))
@@ -268,6 +278,8 @@ EXPORT_SYMBOL(fs_param_is_enum);
 int fs_param_is_string(struct p_log *log, const struct fs_parameter_spec *p,
 		       struct fs_parameter *param, struct fs_parse_result *result)
 {
+	if (param->type == fs_value_is_empty)
+		return 0;
 	if (param->type != fs_value_is_string ||
 	    (!*param->string && !(p->flags & fs_param_can_be_empty)))
 		return fs_param_bad_value(log, param);
@@ -278,6 +290,8 @@ EXPORT_SYMBOL(fs_param_is_string);
 int fs_param_is_blob(struct p_log *log, const struct fs_parameter_spec *p,
 		     struct fs_parameter *param, struct fs_parse_result *result)
 {
+	if (param->type == fs_value_is_empty)
+		return 0;
 	if (param->type != fs_value_is_blob)
 		return fs_param_bad_value(log, param);
 	return 0;
@@ -287,6 +301,8 @@ EXPORT_SYMBOL(fs_param_is_blob);
 int fs_param_is_fd(struct p_log *log, const struct fs_parameter_spec *p,
 		  struct fs_parameter *param, struct fs_parse_result *result)
 {
+	if (param->type == fs_value_is_empty)
+		return 0;
 	switch (param->type) {
 	case fs_value_is_string:
 		if ((!*param->string && !(p->flags & fs_param_can_be_empty)) ||
--- a/include/linux/fs_context.h~vfs-parse-deal-with-zero-length-string-value
+++ a/include/linux/fs_context.h
@@ -50,7 +50,8 @@ enum fs_context_phase {
  */
 enum fs_value_type {
 	fs_value_is_undefined,
-	fs_value_is_flag,		/* Value not given a value */
+	fs_value_is_flag,		/* Does not take a value */
+	fs_value_is_empty,		/* Value is not given */
 	fs_value_is_string,		/* Value is a string */
 	fs_value_is_blob,		/* Value is a binary blob */
 	fs_value_is_filename,		/* Value is a filename* + dirfd */
_

Patches currently in -mm which might be from raven@themaw.net are

ext4-fix-possible-null-pointer-dereference.patch
vfs-parse-deal-with-zero-length-string-value.patch

