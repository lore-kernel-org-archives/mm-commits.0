Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 915CEC77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 23:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjEEX6A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 19:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjEEX57 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 19:57:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6270861AF
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 16:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA3E6615EA
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 23:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B7FC433EF;
        Fri,  5 May 2023 23:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683331076;
        bh=PoU1DMTye2a5zkwcJRepOIgvFW23QIZEgXvM+WZJg7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIvCZvzM2eUopXDnh8jwMsYZITuzsN6z3QANUj4v8H+xj4Xw0MIv8eCLbVqnRjyX2
         E0Xhq34FTAa5ltfI/eng7g9TiQF41d/7zeNU27ILU0uutIm3h2pRtz/uMPJouba8rY
         yly7bXr2i+zkKKjvGzaJvT3YTXHsGBE56f7rnuVFPyTELd/q6G7FHivDI/if/NyzcF
         owOnLh26gfhw6eURxI6BoqyS1717vg84d/kxbnrHACAlDFSaEvUnDm3V+iu0Udhoka
         6Cg5uRrKaSkwYbB+nFkGrmkNWipluZh0bv95kDb94wQE7cFuw98vHgadIYqa2MQVvv
         m2kOBIB6c+5uw==
From:   SeongJae Park <sj@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        rostedt@goodmis.org, pmladek@suse.com, senozhatsky@chromium.org
Subject: Re: [merged] seq_buf-add-seq_buf_do_printk-helper.patch removed from -mm tree
Date:   Fri,  5 May 2023 23:57:54 +0000
Message-Id: <20230505235754.121741-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230505224521.C3D6BC433EF@smtp.kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On Fri, 05 May 2023 15:45:21 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The quilt patch titled
>      Subject: seq_buf: add seq_buf_do_printk() helper
> has been removed from the -mm tree.  Its filename was
>      seq_buf-add-seq_buf_do_printk-helper.patch
> 
> This patch was dropped because it was merged into mainline or a subsystem tree

Just for headup.  I just found the latest mm-unstable indeed dropped the patch
but a patch[1] depends on it.  As a result, build fails as below.

      CC      mm/memcontrol.o
    /mm/memcontrol.c: In function ‘mem_cgroup_print_oom_meminfo’:
    /mm/memcontrol.c:1693:2: error: implicit declaration of function ‘seq_buf_do_printk’; did you mean ‘seq_buf_bprintf’? [-Werror=implicit-function-declaration]
     1693 |  seq_buf_do_printk(&s, KERN_INFO);
          |  ^~~~~~~~~~~~~~~~~
          |  seq_buf_bprintf
    cc1: some warnings being treated as errors

[1] https://lore.kernel.org/mm-commits/20230502201509.B8711C433D2@smtp.kernel.org/


Thanks,
SJ

> 
> ------------------------------------------------------
> From: Sergey Senozhatsky <senozhatsky@chromium.org>
> Subject: seq_buf: add seq_buf_do_printk() helper
> Date: Sat, 15 Apr 2023 19:01:10 +0900
> 
> (akpm: temporary addition for
> memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch)
> 
> Sometimes we use seq_buf to format a string buffer, which we then pass to
> printk().  However, in certain situations the seq_buf string buffer can
> get too big, exceeding the PRINTKRB_RECORD_MAX bytes limit, and causing
> printk() to truncate the string.
> 
> Add a new seq_buf helper.  This helper prints the seq_buf string buffer
> line by line, using as a delimiter, rather than passing the whole string
> buffer to printk() at once.
> 
> Link: https://lkml.kernel.org/r/20230415100110.1419872-1-senozhatsky@chromium.org
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
