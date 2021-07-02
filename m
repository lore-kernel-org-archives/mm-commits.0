Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5149BC07E95
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 18:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1811E6140C
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 18:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhGBSp6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 14:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhGBSp6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 14:45:58 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A93EC061762
        for <mm-commits@vger.kernel.org>; Fri,  2 Jul 2021 11:43:25 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id a14so5876568pls.4
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 11:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bpBKfUXPqjHgQ1sTa/Yk0W/k5e/tQuqcf8rhcnkc4ug=;
        b=C0lwvnlMOvB2b2cLfgEyujGFDkRJiubN/AyH/ujl8PXZQH+bp71SAl69BTkF23Mt3k
         flhg0yKPIZPK9MXipJi2sFewjA7dKrGVBzpVO0rF8r3nOqB1MMHv6ZuJhQIDJGyomTaC
         6Dbq8TVaVYDNygv+VCeqzPSehA1IjVDsphxW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bpBKfUXPqjHgQ1sTa/Yk0W/k5e/tQuqcf8rhcnkc4ug=;
        b=UwfCY42xWmUnSzjMg7+SDyD2HhmqZK4XPyXeafzYhtEMIqqTbrc8phjhW4zEEBitzs
         M4PrZ3eu+0stlj9u1eTOlqrL5z/o773ZDkbEa1k6/NDTY7t+tW4LOK7K8gr+3ISjs2eo
         I4/1/St00Z0hwIhnqsTixY0qv47TEYFipREzqmjcaRmYvQ76LgEcjd8EGQfk139D90uA
         8lJKDwaw4EzwmLj3FOOT1KBA+A0Hh5NYNp8zXkbLiv85w+tXf0lttfBeV1xU+Qaat4Z3
         goYWTqDQMIoRcxVgUBz/sh+cmjp3qcIN1/kfF69qf2DuwDtbRx1aZ26YaVsxahn4G3Dr
         UXFQ==
X-Gm-Message-State: AOAM530UM709JD5RYpjo2HTkzPr3QJ/wBsXgvAJKvggmPev8MzAla9sq
        Q2ZxH8vExiRIA77w6RA2i8mv+w==
X-Google-Smtp-Source: ABdhPJwqcRrBc3jKxWkAOo1mP0DG20HQo+9VAQLueKp0OH0B1iKx1QJF9lb8HiN4SzDFNgtbbq3fIQ==
X-Received: by 2002:a17:90a:e286:: with SMTP id d6mr1042275pjz.157.1625251404842;
        Fri, 02 Jul 2021 11:43:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h10sm4417856pfh.33.2021.07.02.11.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 11:43:24 -0700 (PDT)
Date:   Fri, 2 Jul 2021 11:43:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     adobriyan@gmail.com, avagin@gmail.com, bernd.edlinger@hotmail.de,
        christian.brauner@ubuntu.com, christian.koenig@amd.com,
        corbet@lwn.net, deller@gmx.de, ebiederm@xmission.com,
        gladkov.alexey@gmail.com, hridya@google.com,
        jamorris@linux.microsoft.com, jannh@google.com, jeffv@google.com,
        kaleshsingh@google.com, linux-mm@kvack.org,
        mchehab+huawei@kernel.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        surenb@google.com, szabolcs.nagy@arm.com,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        walken@google.com, willy@infradead.org
Subject: Re: [patch 142/192] procfs: allow reading fdinfo with
 PTRACE_MODE_READ
Message-ID: <202107021047.CC57ED634@keescook>
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015444.ZOZaFPX0b%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
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
> 
>  fs/proc/base.c |    4 ++--
>  fs/proc/fd.c   |   15 ++++++++++++++-
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> --- a/fs/proc/base.c~procfs-allow-reading-fdinfo-with-ptrace_mode_read
> +++ a/fs/proc/base.c
> @@ -3172,7 +3172,7 @@ static const struct pid_entry tgid_base_
>  	DIR("task",       S_IRUGO|S_IXUGO, proc_task_inode_operations, proc_task_operations),
>  	DIR("fd",         S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
>  	DIR("map_files",  S_IRUSR|S_IXUSR, proc_map_files_inode_operations, proc_map_files_operations),
> -	DIR("fdinfo",     S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
> +	DIR("fdinfo",     S_IRUGO|S_IXUGO, proc_fdinfo_inode_operations, proc_fdinfo_operations),
>  	DIR("ns",	  S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
>  #ifdef CONFIG_NET
>  	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
> @@ -3517,7 +3517,7 @@ static const struct inode_operations pro
>   */
>  static const struct pid_entry tid_base_stuff[] = {
>  	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
> -	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
> +	DIR("fdinfo",    S_IRUGO|S_IXUGO, proc_fdinfo_inode_operations, proc_fdinfo_operations),
>  	DIR("ns",	 S_IRUSR|S_IXUGO, proc_ns_dir_inode_operations, proc_ns_dir_operations),
>  #ifdef CONFIG_NET
>  	DIR("net",        S_IRUGO|S_IXUGO, proc_net_inode_operations, proc_net_operations),
> --- a/fs/proc/fd.c~procfs-allow-reading-fdinfo-with-ptrace_mode_read
> +++ a/fs/proc/fd.c
> @@ -6,6 +6,7 @@
>  #include <linux/fdtable.h>
>  #include <linux/namei.h>
>  #include <linux/pid.h>
> +#include <linux/ptrace.h>
>  #include <linux/security.h>
>  #include <linux/file.h>
>  #include <linux/seq_file.h>
> @@ -72,6 +73,18 @@ out:
>  
>  static int seq_fdinfo_open(struct inode *inode, struct file *file)
>  {
> +	bool allowed = false;
> +	struct task_struct *task = get_proc_task(inode);
> +
> +	if (!task)
> +		return -ESRCH;
> +
> +	allowed = ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
> +	put_task_struct(task);
> +
> +	if (!allowed)
> +		return -EACCES;

Uhm, this is only checked in open(), and never again? Is this safe in
the face of exec or pid re-use?

-Kees

> +
>  	return single_open(file, seq_show, inode);
>  }
>  
> @@ -308,7 +321,7 @@ static struct dentry *proc_fdinfo_instan
>  	struct proc_inode *ei;
>  	struct inode *inode;
>  
> -	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFREG | S_IRUSR);
> +	inode = proc_pid_make_inode(dentry->d_sb, task, S_IFREG | S_IRUGO);
>  	if (!inode)
>  		return ERR_PTR(-ENOENT);
>  
> _

-- 
Kees Cook
