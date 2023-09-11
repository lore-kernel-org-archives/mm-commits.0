Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74344CA0EC6
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 03:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbjILDI2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 23:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbjILDIK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 23:08:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB179D961
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 16:13:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43388C116A8;
        Mon, 11 Sep 2023 21:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694469597;
        bh=59BkdiUJyd32KEyc+n0Dp5VUg2jT7Xft9rxbazv05iA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mtk6JsLBDu12J01Of2UoDlAmnhrEe+qHj5Va360GHjsz+FeeGO33umlHyNzATh39P
         Car0XealbN9oeDKQt1OBDwM449Q/gxzF5mf8WmlgBLbim3nqKA8s0ZchnWAsLjj2p+
         vr35bO+CWMeBuz0lP0w5eDH+oIEZr5R58aOR1hjU=
Date:   Mon, 11 Sep 2023 14:59:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     mm-commits@vger.kernel.org, herve.codina@bootlin.com
Subject: Re: + minmax-deduplicate-__unconst_integer_typeof.patch added to
 mm-nonmm-unstable branch
Message-Id: <20230911145956.7b36e463d16583cede78b2b6@linux-foundation.org>
In-Reply-To: <ZP+K/zh7zVATnrTE@smile.fi.intel.com>
References: <20230911182556.ED7D7C433C7@smtp.kernel.org>
        <ZP+K/zh7zVATnrTE@smile.fi.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 12 Sep 2023 00:47:43 +0300 Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> > -/*
> >   * Do not check the array parameter using __must_be_array().
> >   * In the following legit use-case where the "array" passed is a simple pointer,
> >   * __must_be_array() will return a failure.
> 
> A side note: If you look at the original email and patch you will see a subtle
> difference that makes patch better looking. It's because I started using
> --patience when formatting them. Perhaps you can enable it in your scripts.

Interesting, thanks.

I use plain old diff :(.  A while back I had everything working (I
thought) using `git diff' instead but found that it was producing diffs that
gave git-quiltimport a heart attack.  Ran out of time, didn't debug,
disabled it.  I'll revisit at some point.

