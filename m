Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B836DC11F68
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 14:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A1C761413
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 14:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhGBO4p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 10:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230271AbhGBO4o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Jul 2021 10:56:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B2746140C;
        Fri,  2 Jul 2021 14:54:06 +0000 (UTC)
Date:   Fri, 2 Jul 2021 16:54:03 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     adobriyan@gmail.com, avagin@gmail.com, bernd.edlinger@hotmail.de,
        christian.koenig@amd.com, corbet@lwn.net, deller@gmx.de,
        ebiederm@xmission.com, gladkov.alexey@gmail.com, hridya@google.com,
        jamorris@linux.microsoft.com, jannh@google.com, jeffv@google.com,
        kaleshsingh@google.com, keescook@chromium.org, linux-mm@kvack.org,
        mchehab+huawei@kernel.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        surenb@google.com, szabolcs.nagy@arm.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        walken@google.com, willy@infradead.org
Subject: Re: [patch 142/192] procfs: allow reading fdinfo with
 PTRACE_MODE_READ
Message-ID: <20210702145403.asuwl5mmvyxhzs5o@wittgenstein>
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015444.ZOZaFPX0b%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210701015444.ZOZaFPX0b%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jun 30, 2021 at 06:54:44PM -0700, Andrew Morton wrote:
> From: Kalesh Singh <kaleshsingh@google.com>
> Subject: procfs: allow reading fdinfo with PTRACE_MODE_READ
> 
> Android captures per-process system memory state when certain low memory
> events (e.g a foreground app kill) occur, to identify potential memory
> hoggers.  In order to measure how much memory a process actually consumes,
> it is necessary to include the DMA buffer sizes for that process in the
> memory accounting.  Since the handle to DMA buffers are raw FDs, it is
> important to be able to identify which processes have FD references to a
> DMA buffer.
> 
> Currently, DMA buffer FDs can be accounted using /proc/<pid>/fd/* and
> /proc/<pid>/fdinfo -- both are only readable by the process owner, as
> follows:
> 
>   1. Do a readlink on each FD.
>   2. If the target path begins with "/dmabuf", then the FD is a dmabuf FD.
>   3. stat the file to get the dmabuf inode number.
>   4. Read/ proc/<pid>/fdinfo/<fd>, to get the DMA buffer size.
> 
> Accessing other processes' fdinfo requires root privileges.  This limits
> the use of the interface to debugging environments and is not suitable for
> production builds.  Granting root privileges even to a system process
> increases the attack surface and is highly undesirable.
> 
> Since fdinfo doesn't permit reading process memory and manipulating
> process state, allow accessing fdinfo under PTRACE_MODE_READ_FSCRED.
> 
> Link: https://lkml.kernel.org/r/20210308170651.919148-1-kaleshsingh@google.com
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> Suggested-by: Jann Horn <jannh@google.com>
> Acked-by: Christian König <christian.koenig@amd.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
> Cc: Andrei Vagin <avagin@gmail.com>
> Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Hridya Valsaraju <hridya@google.com>
> Cc: James Morris <jamorris@linux.microsoft.com>
> Cc: Jeff Vander Stoep <jeffv@google.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Rather useful (also for CRIU and others).
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
