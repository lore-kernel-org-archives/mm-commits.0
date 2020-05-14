From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 13 May 2020 17:50:05 -0700
Message-ID: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728481AbgENAuG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 May 2020 20:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org

7 fixes, based on 24085f70a6e1b0cb647ec92623284641d8270637:

    Yafang Shao <laoar.shao@gmail.com>:
      mm, memcg: fix inconsistent oom event behavior

    Roman Penyaev <rpenyaev@suse.de>:
      epoll: call final ep_events_available() check under the lock

    Peter Xu <peterx@redhat.com>:
      mm/gup: fix fixup_user_fault() on multiple retries

    Brian Geffon <bgeffon@google.com>:
      userfaultfd: fix remap event with MREMAP_DONTUNMAP

    Vasily Averin <vvs@virtuozzo.com>:
      ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

    Andrey Konovalov <andreyknvl@google.com>:
      kasan: consistently disable debugging features
      kasan: add missing functions declarations to kasan.h

 fs/eventpoll.c             |   48 ++++++++++++++++++++++++++-------------------
 include/linux/memcontrol.h |    2 +
 ipc/util.c                 |   12 +++++------
 mm/gup.c                   |   12 ++++++-----
 mm/kasan/Makefile          |   15 +++++++++-----
 mm/kasan/kasan.h           |   34 ++++++++++++++++++++++++++++++-
 mm/mremap.c                |    2 -
 7 files changed, 86 insertions(+), 39 deletions(-)
