From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 7 May 2020 18:35:09 -0700
Message-ID: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbgEHBfK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 21:35:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org


14 fixes and one selftest to verify the ipc fixes herein.


15 patches, based on a811c1fa0a02c062555b54651065899437bacdbe:


    Oleg Nesterov <oleg@redhat.com>:
      ipc/mqueue.c: change __do_notify() to bypass check_kill_permission()

    Yafang Shao <laoar.shao@gmail.com>:
      mm, memcg: fix error return value of mem_cgroup_css_alloc()

    David Hildenbrand <david@redhat.com>:
      mm/page_alloc: fix watchdog soft lockups during set_zone_contiguous()

    Maciej Grochowski <maciej.grochowski@pm.me>:
      kernel/kcov.c: fix typos in kcov_remote_start documentation

    Ivan Delalande <colona@arista.com>:
      scripts/decodecode: fix trapping instruction formatting

    Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>:
      arch/x86/kvm/svm/sev.c: change flag passed to GUP fast in sev_pin_memory()

    Khazhismel Kumykov <khazhy@google.com>:
      eventpoll: fix missing wakeup for ovflist in ep_poll_callback

    Aymeric Agon-Rambosson <aymeric.agon@yandex.com>:
      scripts/gdb: repair rb_first() and rb_last()

    Waiman Long <longman@redhat.com>:
      mm/slub: fix incorrect interpretation of s->offset

    Filipe Manana <fdmanana@suse.com>:
      percpu: make pcpu_alloc() aware of current gfp context

    Roman Penyaev <rpenyaev@suse.de>:
      kselftests: introduce new epoll60 testcase for catching lost wakeups
      epoll: atomically remove wait entry on wake up

    Qiwu Chen <qiwuchen55@gmail.com>:
      mm/vmscan: remove unnecessary argument description of isolate_lru_pages()

    Kees Cook <keescook@chromium.org>:
      ubsan: disable UBSAN_ALIGNMENT under COMPILE_TEST

    Henry Willard <henry.willard@oracle.com>:
      mm: limit boost_watermark on small zones

 arch/x86/kvm/svm/sev.c                                        |    2 
 fs/eventpoll.c                                                |   61 ++--
 ipc/mqueue.c                                                  |   34 +-
 kernel/kcov.c                                                 |    4 
 lib/Kconfig.ubsan                                             |   15 -
 mm/memcontrol.c                                               |   15 -
 mm/page_alloc.c                                               |    9 
 mm/percpu.c                                                   |   14 
 mm/slub.c                                                     |   45 ++-
 mm/vmscan.c                                                   |    1 
 scripts/decodecode                                            |    2 
 scripts/gdb/linux/rbtree.py                                   |    4 
 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c |  146 ++++++++++
 tools/testing/selftests/wireguard/qemu/debug.config           |    1 
 14 files changed, 275 insertions(+), 78 deletions(-)
