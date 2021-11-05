Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36D0C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90A9D6136F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhKEUsm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233729AbhKEUsl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:48:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E02D61288;
        Fri,  5 Nov 2021 20:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145161;
        bh=dLpCXweS9BQ/c81WVkbFG2RJg1JdzJeDs/+gsEXIuDg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=boyF2jlCyzlmAtDI3gmK1TnpLE7rJTUZe7Wfwobaut5Kxt54+WYDMArNUSyOhTCh9
         Tg7DnkmVJsfTQyGLtuaLDkWulCekjmOxRx/nWbnZt999BF0TqhZBQD4uJx5gQyCUks
         aRZHZFur3jUDBGVU12kZakLNLQ6pU5ct/75S0Zh0=
Date:   Fri, 05 Nov 2021 13:46:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjpark@amazon.de,
        torvalds@linux-foundation.org
Subject:  [patch 217/262] docs/vm/damon: remove broken reference
Message-ID: <20211105204601.1bYw-dhvK%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sjpark@amazon.de>
Subject: docs/vm/damon: remove broken reference

Building DAMON documents warns for a reference to nonexisting doc, as
below:

    $ time make htmldocs
    [...]
    Documentation/vm/damon/index.rst:24: WARNING: toctree contains reference to nonexisting document 'vm/damon/plans'

This commit fixes the warning by removing the wrong reference.

Link: https://lkml.kernel.org/r/20210917123958.3819-4-sj@kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/damon/index.rst |    1 -
 1 file changed, 1 deletion(-)

--- a/Documentation/vm/damon/index.rst~docs-vm-damon-remove-broken-reference
+++ a/Documentation/vm/damon/index.rst
@@ -27,4 +27,3 @@ workloads and systems.
    faq
    design
    api
-   plans
_
