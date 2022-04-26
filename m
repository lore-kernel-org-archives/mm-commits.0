Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068EFC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 26 Apr 2022 22:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355658AbiDZWQR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Apr 2022 18:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiDZWQR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2022 18:16:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EB03B570
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 15:13:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9095DB82351
        for <mm-commits@vger.kernel.org>; Tue, 26 Apr 2022 22:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4399C385A0;
        Tue, 26 Apr 2022 22:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651011186;
        bh=Uqo+WiZwtjFuPVu3bdiy2tPh/hk+/kTJ/uXFyxV0c70=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QxK7QvHYEfORnTVYoBIMV0+OqJhdkWyf65nTnov339KhBfJGB5dtR1sLGG5HJbMx1
         +2nhzPHdIavAO7d321/1YJUfx45IhqeD8wz7t5YqgaGNTPkF4gqRrJGsWXYawZahKp
         asB+Tg4yifsLAg0pl/X3J+QQ8WYz5sKDXsv7ZyQg=
Date:   Tue, 26 Apr 2022 15:13:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     mm-commits@vger.kernel.org, will@kernel.org, luto@kernel.org,
        catalin.marinas@arm.com, alex.popov@linux.com, mark.rutland@arm.com
Subject: Re: + arm64-entry-use-stackleak_erase_on_task_stack.patch added to
 -mm tree
Message-Id: <20220426151305.c67898efead03ba4d17cc2f5@linux-foundation.org>
In-Reply-To: <202204261417.41B52508@keescook>
References: <20220426205142.13A38C385A0@smtp.kernel.org>
        <202204261417.41B52508@keescook>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 26 Apr 2022 14:18:20 -0700 Kees Cook <keescook@chromium.org> wrote:

> I don't think these should be applied to -mm. They would normally go via
> my hardening tree (with other gcc plugins), but also Mark is going to be
> spinning a v2...

Yep, sorry, that was a brainfart.
